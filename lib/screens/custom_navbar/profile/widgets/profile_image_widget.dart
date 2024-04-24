import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:people_talk/constants/app_colors.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:provider/provider.dart';

import '../../../../constants/loading_indicator.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<GetUserData>(context).userModel;
    return userController.image == ""
        ? Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryGrey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset("assets/images/person.png", color: AppColors.primaryGrey),
            ),
          )
        : SizedBox(
            height: 80,
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: userController.image!,
                placeholder: (context, url) => spinKit2,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}
