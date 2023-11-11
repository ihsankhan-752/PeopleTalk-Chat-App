import 'package:flutter/material.dart';
import 'package:people_talk/themes/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  const PrimaryButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.mainColor.withOpacity(0.8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
