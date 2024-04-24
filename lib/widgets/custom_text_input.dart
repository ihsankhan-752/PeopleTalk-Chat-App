import 'package:flutter/material.dart';
import 'package:people_talk/constants/app_colors.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType? inputType;
  final bool isIconReq;
  final bool isVisible;
  final Widget? widget;
  final int? maxLines;

  const CustomTextInput(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isIconReq = false,
      this.isVisible = false,
      this.widget,
      this.maxLines,
      this.inputType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: inputType ?? TextInputType.text,
      maxLines: maxLines ?? 1,
      obscureText: isVisible,
      cursorColor: AppColors.primaryWhite,
      style: TextStyle(
        color: AppColors.primaryWhite,
      ),
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryGrey, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryGrey, width: 0.5),
        ),
        hintText: hintText,
        suffixIcon: isIconReq ? widget : const SizedBox(),
        hintStyle: TextStyle(
          color: AppColors.primaryGrey,
          fontSize: 14,
        ),
        border: InputBorder.none,
      ),
    );
  }
}
