import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'custom_list_tile.dart';

uploadPhotoOptionWidget({BuildContext? context, Function()? onCameraClicked, Function()? onGalleryClicked}) {
  return showModalBottomSheet(
    backgroundColor: AppColors.primaryColor,
    context: context!,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Source",
                style: TextStyle(
                  color: AppColors.primaryWhite,
                  fontSize: 22,
                )),
            const SizedBox(height: 20),
            CustomListTile(
              onPressed: onCameraClicked,
              icon: Icons.camera_alt_outlined,
              title: "Camera",
            ),
            const SizedBox(height: 10),
            CustomListTile(
              onPressed: onGalleryClicked,
              icon: Icons.photo,
              title: "From Gallery",
            ),
            const SizedBox(height: 10),
            CustomListTile(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icons.cancel_outlined,
              title: "Cancel",
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
