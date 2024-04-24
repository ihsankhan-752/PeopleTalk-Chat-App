import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text.dart';

class SearchTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String? v)? onChanged;
  const SearchTextInput({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged ?? (v) {},
      style: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 14,
      ),
      cursorColor: AppColors.primaryWhite,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        filled: true,
        fillColor: AppColors.primaryBlack,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.search, size: 20, color: AppColors.primaryWhite),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: AppText.search,
        hintStyle: TextStyle(
          color: AppColors.primaryWhite,
        ),
      ),
    );
  }
}
