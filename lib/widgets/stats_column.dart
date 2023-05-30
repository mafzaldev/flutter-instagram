import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/app_colors.dart';

class StatsColumn extends StatelessWidget {
  final String label;
  final String value;
  const StatsColumn({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
