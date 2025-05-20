import 'package:flutter/material.dart';
import 'package:ulmo/features/profile/presentation/widgets/my_details_screen.dart';
import 'package:ulmo/features/profile/presentation/widgets/my_orders_screen.dart';
import 'package:ulmo/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileMenuSection extends StatelessWidget {
  final VoidCallback? onSignOut;

  const ProfileMenuSection({
    Key? key,
    this.onSignOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'My orders',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyOrdersScreen(),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.person_outline,
          title: 'My Details',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyDetailsScreen(),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Address book',
          onTap: () {
            // Navigate to address book screen
          },
        ),
        ProfileMenuItem(
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          onTap: () {
            // Navigate to payment methods screen
          },
        ),
        ProfileMenuItem(
          icon: Icons.logout_outlined,
          title: 'Sign out',
          showDivider: false,
          onTap: onSignOut,
        ),
      ],
    );
  }
}
