import 'package:flutter/material.dart';

class FilterRowWidget extends StatelessWidget {
  final String? label;
  final String? selectedValue; // Make this nullable
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const FilterRowWidget({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          DropdownButton<String>(
            value: selectedValue,  // This can now be null
            hint: const Text("Select Category"),  // Optional hint when no selection is made
            icon: const Icon(Icons.arrow_drop_down),
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: onChanged,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
