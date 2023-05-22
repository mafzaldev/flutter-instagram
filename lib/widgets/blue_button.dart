import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/app_colors.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const BlueButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(text,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
