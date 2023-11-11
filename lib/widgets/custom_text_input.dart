import 'package:flutter/material.dart';
import 'package:people_talk/themes/app_colors.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isIconReq;
  final bool isVisible;
  final Widget? widget;
  final String? Function(String? v)? validator;

  const CustomTextInput(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isIconReq = false,
      this.validator,
      this.isVisible = false,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(08),
        border: Border.all(color: AppColors.bgColor),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 08, top: 2),
        child: TextFormField(
          validator: validator!,
          obscureText: isVisible,
          cursorColor: AppColors.primaryWhite,
          style: TextStyle(
            color: AppColors.primaryWhite,
          ),
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: isIconReq ? widget : const SizedBox(),
            hintStyle: TextStyle(
              color: AppColors.primaryGrey,
              fontSize: 14,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
