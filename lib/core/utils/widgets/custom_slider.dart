import 'package:flutter/material.dart';

import '../../themes/colors_style.dart';

class CustomSlider extends StatefulWidget {
  final double min;
  final double max;
  final double initialValue;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    Key? key,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: widget.min,
      max: widget.max,
      divisions: (widget.max - widget.min).round(), // optional
      label: currentValue.round().toString(),
      value: currentValue,
      activeColor: AppColors.primary,
      inactiveColor: AppColors.backgroundLight,
      onChanged: (newVal) {
        setState(() {
          currentValue = newVal;
        });
        widget.onChanged(newVal);
      },
    );
  }
}