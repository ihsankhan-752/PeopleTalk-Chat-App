import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../models/user_model.dart';
import '../chat_main_screen.dart';

class UserChatCard extends StatelessWidget {
  final UserModel userModel;
  final String? msg;
  final DateTime? msgTime;
  const UserChatCard({super.key, required this.userModel, this.msg, this.msgTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => ChatMainScreen(userId: userModel.userId!, username: userModel.username!, userImage: userModel.image!));
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: userModel.image == ""
                  ? CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 30,
                      child: Center(
                        child: Text(
                          userModel.username![0].toUpperCase(),
                          style: AppTextStyle.h1.copyWith(fontSize: 22),
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(userModel.image!),
                    ),
              title: Text(userModel.username!, style: AppTextStyle.h1),
              subtitle: Text(
                msg!,
                style: AppTextStyle.h1.copyWith(
                  fontSize: 12,
                  color: AppColors.primaryGrey,
                ),
              ),
              trailing: Text(
                timeago.format(msgTime!),
                style: AppTextStyle.h1.copyWith(fontSize: 10),
              ),
            ),
          ),
          Divider(color: AppColors.primaryColor),
        ],
      ),
    );
  }
}
