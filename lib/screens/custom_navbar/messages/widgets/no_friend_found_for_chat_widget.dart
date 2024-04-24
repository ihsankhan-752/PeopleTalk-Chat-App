import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_style.dart';

class NoFriendFoundForChatWidget extends StatelessWidget {
  final String image;
  final String title;
  const NoFriendFoundForChatWidget({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: Get.height * 0.18,
              width: Get.width * 0.5,
              child: Image.asset(image),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.h1.copyWith(
              fontSize: 25,
              color: AppColors.primaryGrey,
            ),
          )
        ],
      ),
    );
  }
}
