import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_style.dart';

class NoSearchWidget extends StatelessWidget {
  const NoSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            height: Get.height * 0.3,
            width: Get.width * 0.8,
            child: Image.asset('assets/images/add_friend.png', fit: BoxFit.cover),
          ),
          const SizedBox(height: 30),
          Text(
            "Find Your Friends",
            style: AppTextStyle.h1.copyWith(
              fontSize: 18,
              color: AppColors.primaryGrey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.center,
              "Search your friend name for adding to your Friend List",
              style: AppTextStyle.h1.copyWith(
                fontSize: 16,
                color: AppColors.primaryWhite,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
