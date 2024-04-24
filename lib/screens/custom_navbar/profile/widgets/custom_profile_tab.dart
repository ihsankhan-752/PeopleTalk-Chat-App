import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_style.dart';

class CustomProfileTab extends StatelessWidget {
  final String? title, image;
  final Function()? onPressed;
  final Color? textColor;
  final Color? iconColor;
  const CustomProfileTab({super.key, this.title, this.onPressed, this.textColor, this.image, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 50,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              SizedBox(height: 22, width: 22, child: Image.asset(image!, color: iconColor ?? AppColors.primaryWhite)),
              const SizedBox(width: 20),
              Text(
                title!,
                style: AppTextStyle.h1.copyWith(
                  color: textColor ?? AppColors.primaryWhite,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
