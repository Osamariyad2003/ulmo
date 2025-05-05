import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/di/di.dart';
import 'package:ulmo/features/profile/presentation/controller/profile_bloc.dart';
import 'package:ulmo/features/profile/presentation/controller/profile_event.dart';
import 'package:ulmo/features/profile/presentation/controller/profile_state.dart';
import 'package:ulmo/features/profile/presentation/widgets/profile_header.dart';
import 'package:ulmo/features/profile/presentation/widgets/profile_meun_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<ProfileBloc>()..add(LoadProfile()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileHeader(
                        title: 'my account',
                        showBackButton: false,
                      ),
                      const SizedBox(height: 24),
                      _buildProfileInfo(state),
                      const SizedBox(height: 32),
                      ProfileMenuSection(
                        onSignOut: () {
                          context.read<ProfileBloc>().add(SignOut());
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(ProfileState state) {
    if (state is ProfileLoading) {
      return _buildLoadingProfileInfo();
    } else if (state is ProfileError) {
      return _buildErrorProfileInfo(state.message);
    } else if (state is ProfileLoaded || state is ProfileUpdated) {
      final user =
          state is ProfileLoaded ? state.user : (state as ProfileUpdated).user;
      return ProfileInfo(
        name: user.username ?? 'User',
        phone: user.phoneNumber ?? 'No phone',
        avatarUrl: user.avatarUrl,
      );
    } else if (state is ProfileSignedOut) {
      // Handle signed out state by navigating to login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      });
      return const SizedBox.shrink();
    } else {
      return _buildDefaultProfileInfo();
    }
  }

  Widget _buildLoadingProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 18,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorProfileInfo(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error loading profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.read<ProfileBloc>().add(LoadProfile());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultProfileInfo() {
    // Fallback default profile info when state is not handled
    return const ProfileInfo(
      name: 'Guest User',
      phone: 'No phone number',
    );
  }
}
