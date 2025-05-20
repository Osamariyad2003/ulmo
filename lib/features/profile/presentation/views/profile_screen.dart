import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/app_router/routers.dart';
import 'package:ulmo/features/delivery/presentation/views/address_list_screen.dart';
import 'package:ulmo/features/profile/presentation/controller/profile_bloc.dart';
import 'package:ulmo/features/profile/presentation/controller/profile_event.dart';
import 'package:ulmo/features/profile/presentation/controller/profile_state.dart';
import 'package:ulmo/features/profile/presentation/widgets/my_details_screen.dart';
import 'package:ulmo/features/profile/presentation/widgets/my_orders_screen.dart';
import 'package:ulmo/features/profile/presentation/widgets/payment_methods_widget.dart';
import 'package:ulmo/features/profile/presentation/widgets/profile_screen_states_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(context),
          Expanded(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileInfo(state, context),
                        const SizedBox(height: 32),
                        _buildMenuSection(context),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'my account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(ProfileState state, BuildContext context) {
    if (state is ProfileLoading) {
      return const LoadingProfileInfo();
    } else if (state is ProfileError) {
      return ErrorProfileInfo(message: state.message);
    } else if (state is ProfileLoaded || state is ProfileUpdated) {
      final user =
          state is ProfileLoaded ? state.user : (state as ProfileUpdated).user;
      return ProfileInfo(
        name: user.username ?? 'User',
        phone: user.phoneNumber ?? 'No phone',
        avatarUrl: user.avatarUrl,
      );
    } else if (state is ProfileSignedOut) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
      });
      return SizedBox.shrink();
    } else {
      return ProfileInfo(name: 'Guest User', phone: 'No phone number');
    }
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        MenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'My orders',
          trailingText: '14',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyOrdersScreen()),
            );
          },
        ),
        MenuItem(
          icon: Icons.person_outline,
          title: 'My Details',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyDetailsScreen()),
            );
          },
        ),
        MenuItem(
          icon: Icons.location_on_outlined,
          title: 'Address book',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressListScreen()),
            );
          },
        ),
        MenuItem(
          icon: Icons.credit_card_outlined,
          title: 'Payment Methods',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentMethodsWidget()),
            );
          },
        ),
        MenuItem(
          icon: Icons.logout_outlined,
          title: 'Sign out',
          onTap: () {
            context.read<ProfileBloc>().add(SignOut());
          },
        ),
      ],
    );
  }
}
