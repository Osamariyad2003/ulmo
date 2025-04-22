import 'package:flutter/material.dart';

class HourSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const HourSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  List<String> _generateTimes() {
    return List.generate(24, (index) {
      final hour = index.toString().padLeft(2, '0');
      return '$hour:00';
    });
  }

  @override
  Widget build(BuildContext context) {
    final times = _generateTimes();

    return Wrap(
      children: List.generate(times.length, (index) {
        final isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onSelect(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: const EdgeInsets.only(right: 8, bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              times[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}
