import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onPressed;

  const FilterButton({
    Key? key,
    required this.itemCount,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[700],
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          'Show $itemCount items',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
