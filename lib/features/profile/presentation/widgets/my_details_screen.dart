import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/di.dart';
import '../../data/repo/profile_repo.dart';
import '../controller/profile_bloc.dart';
import '../controller/profile_event.dart';
import '../controller/profile_state.dart';

class MyDetailsScreen extends StatefulWidget {
  const MyDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MyDetailsScreen> createState() => _MyDetailsScreenState();
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  bool _isLoading = false;
  bool _formChanged = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Load user profile data when screen opens
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              // Populate form fields with user data
              _fullNameController.text = state.user.username ?? '';
              _phoneController.text = state.user.phoneNumber ?? '';
              _emailController.text = state.user.email ?? '';
              setState(() {
                _formChanged = false;
              });
            } else if (state is ProfilePhotoUploaded) {
              // Photo upload was successful
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Profile photo updated successfully')),
              );
              setState(() {
                _isLoading = false;
              });
            } else if (state is ProfileUpdated) {
              // Show success message and reset form change tracking
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
              setState(() {
                _formChanged = false;
                _isLoading = false;
              });
            } else if (state is ProfilePasswordChanged) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully')),
              );
              setState(() {
                _isLoading = false;
                _currentPasswordController.clear();
              });
            } else if (state is ProfileError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
              setState(() {
                _isLoading = false;
              });
            } else if (state is ProfileLoading) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  onChanged: () {
                    if (!_formChanged) {
                      setState(() {
                        _formChanged = true;
                      });
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with back button and save option
                      _buildHeader(),

                      const SizedBox(height: 30),

                      // Profile photo
                      _buildProfilePhoto(state),

                      const SizedBox(height: 24),

                      // Form fields
                      _buildTextField(
                        controller: _fullNameController,
                        label: 'Full name',
                        validator: (value) => value?.isEmpty == true
                            ? 'Name cannot be empty'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty == true) return null;
                          final emailRegExp =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          return emailRegExp.hasMatch(value ?? '')
                              ? null
                              : 'Enter a valid email';
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password field for verification
                      _buildPasswordField(),

                      const SizedBox(height: 40),

                      // Change password button
                      _buildChangePasswordButton(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            const Text(
              'My details',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: _formChanged ? _saveProfile : null,
          child: Text(
            'Save',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _formChanged ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePhoto(ProfileState state) {
    String? avatarUrl;
    if (state is ProfileLoaded) {
      avatarUrl = state.user.avatarUrl;
    }

    return Center(
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: _selectedImage != null
                  ? DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
              color: Colors.grey[200],
            ),
            child: _selectedImage == null && avatarUrl == null
                ? const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  )
                : null,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _pickImage,
            child: const Text(
              'Change photo',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current password',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _currentPasswordController,
          obscureText: _obscurePassword,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          if (_currentPasswordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Please enter your current password')),
            );
            return;
          }
          // Show change password dialog
          _showChangePasswordDialog();
        },
        child: const Text(
          'Change password',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Future<void> _showChangePasswordDialog() async {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // New password field with requirements
              const Text(
                'New password must contain:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• At least 8 characters\n• At least 1 uppercase letter\n• At least 1 number\n• At least 1 special character',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // New password field
              TextField(
                controller: newPasswordController,
                obscureText: obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureNewPassword = !obscureNewPassword;
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  // You could add real-time password strength validation here
                  setState(() {});
                },
              ),

              const SizedBox(height: 16),

              // Confirm password field
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                  ),
                  errorText: confirmPasswordController.text.isNotEmpty &&
                          confirmPasswordController.text !=
                              newPasswordController.text
                      ? 'Passwords don\'t match'
                      : null,
                ),
                onChanged: (value) {
                  // Force rebuild to check password match
                  setState(() {});
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Validate password requirements
                final password = newPasswordController.text;
                if (password.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Password must be at least 8 characters long')),
                  );
                  return;
                }

                if (!RegExp(r'[A-Z]').hasMatch(password)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Password must contain at least one uppercase letter')),
                  );
                  return;
                }

                if (!RegExp(r'[0-9]').hasMatch(password)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Password must contain at least one number')),
                  );
                  return;
                }

                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Password must contain at least one special character')),
                  );
                  return;
                }

                if (newPasswordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }

                // Change password
                context.read<ProfileBloc>().add(
                      ChangePassword(
                        currentPassword: _currentPasswordController.text,
                        newPassword: newPasswordController.text,
                      ),
                    );

                Navigator.of(context).pop();
              },
              child: const Text('Change'),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Directly add event to bloc to handle image upload
        context.read<ProfileBloc>().add(UploadProfilePhoto(
              photo: File(pickedFile.path),
            ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Create profile data map
    final profileData = {
      'fullName': _fullNameController.text,
      'phoneNumber': _phoneController.text,
      'email': _emailController.text,
    };

    if (_selectedImage != null) {
      // Upload image and update profile
      context.read<ProfileBloc>().add(
            UpdateProfileWithPhoto(
              profileData: profileData,
              photo: _selectedImage!,
            ),
          );
    } else {
      // Just update profile data
      context.read<ProfileBloc>().add(
            UpdateProfile(profileData: profileData),
          );
    }
  }
}
