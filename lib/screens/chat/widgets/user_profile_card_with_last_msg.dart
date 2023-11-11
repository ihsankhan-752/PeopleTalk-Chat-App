import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:people_talk/models/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_style.dart';

class UserProfileCardWithLastMsg extends StatelessWidget {
  final String? msg;
  final UserModel userModel;
  final DateTime? createdAt;
  final Function()? onPressed;
  const UserProfileCardWithLastMsg({super.key, required this.userModel, this.msg, this.createdAt, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onPressed ?? () {},
          leading: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: userModel.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal.withOpacity(0.5),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          title: Text(
            userModel.username!,
            style: AppTextStyle.h1.copyWith(
              color: Colors.teal,
            ),
          ),
          subtitle: Text(
            msg!,
            style: AppTextStyle.h1.copyWith(
              fontSize: 12,
              color: AppColors.primaryGrey,
            ),
          ),
          trailing: Text(
            timeago.format(createdAt!),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ),
        const Divider(thickness: 0.1, height: 0.5),
      ],
    );
  }
}
