import 'package:flutter/material.dart';
import 'package:ulmo/features/profile/presentation/widgets/my_details_screen.dart';
import 'package:ulmo/features/profile/presentation/widgets/my_orders_screen.dart';
import 'package:ulmo/features/profile/presentation/widgets/payment_methods_widget.dart';
import 'profile_menu_item.dart';

class ProfileMenuSection extends StatelessWidget {
  final Function() onSignOutTap;

  const ProfileMenuSection({Key? key, required this.onSignOutTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        ProfileMenuItem(
          icon: Icons.account_circle_outlined,
          title: 'Account Settings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyDetailsScreen()),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'Orders',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyOrdersScreen()),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.credit_card_outlined,
          title: 'Payment Methods',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaymentMethodsWidget(),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.logout,
          title: 'Sign Out',
          onTap: onSignOutTap,
        ),
      ],
    );
  }
}
