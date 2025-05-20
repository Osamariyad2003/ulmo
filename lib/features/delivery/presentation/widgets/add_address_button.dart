import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/delivery/presentation/controller/delivery_bloc.dart';
import 'package:ulmo/features/delivery/presentation/controller/delivery_event.dart'
    show LoadSavedAddresses;

class AddAddressButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AddAddressButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Add new address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
