import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const DateSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  List<String> _generateDates() {
    final now = DateTime.now();
    return List.generate(14, (index) {
      final date = now.add(Duration(days: index + 1));
      if (index == 0) return 'Tomorrow';
      return DateFormat('MMM d').format(date); // e.g., Jun 25
    });
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateDates();

    return Wrap(
      children: List.generate(dates.length, (index) {
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
              dates[index],
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
