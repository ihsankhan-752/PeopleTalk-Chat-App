import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../utils/app_text.dart';

class SearchTextInput extends StatelessWidget {
  const SearchTextInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.sizeOf(context).width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.primaryGrey.withOpacity(.5),
      ),
      child: TextField(
        cursorColor: AppColors.primaryWhite,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Icon(Icons.search, size: 20, color: AppColors.primaryWhite),
          ),
          hintText: AppText.search,
          hintStyle: TextStyle(
            color: AppColors.primaryWhite,
          ),
        ),
      ),
    );
  }
}
