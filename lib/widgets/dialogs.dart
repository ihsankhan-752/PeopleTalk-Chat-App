import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/app_text_style.dart';

import '../constants/app_colors.dart';

customAlertDialog({required BuildContext context, required String content, required Function() onPressed}) {
  return CoolAlert.show(
    barrierDismissible: true,
    context: context,
    title: "Wait!",
    text: content,
    textTextStyle: AppTextStyle.h1.copyWith(color: AppColors.primaryBlack),
    type: CoolAlertType.warning,
    onCancelBtnTap: () {
      Get.back();
    },
    onConfirmBtnTap: onPressed,
    loopAnimation: true,
    cancelBtnText: "No",
    confirmBtnText: "Yes",
    confirmBtnColor: AppColors.primaryColor,
  );
}
