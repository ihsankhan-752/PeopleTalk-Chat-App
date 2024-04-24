import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/app_colors.dart';

import '../constants/app_text_style.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Color? btnColor;
  const PrimaryButton({super.key, required this.title, this.onPressed, this.btnColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: btnColor ?? AppColors.primaryColor,
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

class SuggestionButton extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final Color? bgColor;
  final double? width, height;
  const SuggestionButton({super.key, this.title, this.onPressed, this.bgColor, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 35,
      width: width ?? Get.width * 0.42,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )),
        onPressed: onPressed,
        child: Text(
          title!,
          style: AppTextStyle.h1.copyWith(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class AddFriendOrGroupBtn extends StatelessWidget {
  final IconData? icon;
  final Function()? onPressed;
  final String? title;
  const AddFriendOrGroupBtn({super.key, this.onPressed, this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(icon!, size: 20, color: AppColors.primaryWhite),
              const SizedBox(width: 05),
              Text(title!, style: AppTextStyle.main.copyWith(fontSize: 12, letterSpacing: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
