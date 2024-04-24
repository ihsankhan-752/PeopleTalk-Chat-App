import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/app_colors.dart';

showCustomMsg(String msg) {
  Get.snackbar(
    msg,
    "",
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(milliseconds: 1200),
    backgroundColor: AppColors.mainColor,
    colorText: AppColors.primaryWhite,
    margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
    snackStyle: SnackStyle.FLOATING,
  );
}

showErrorMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
}
