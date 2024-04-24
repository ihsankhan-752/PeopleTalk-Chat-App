import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/loading_indicator.dart';
import '../../../../controllers/image_controller.dart';
import '../../../../services/user_profile_services.dart';
import '../../../../widgets/upload_photo_option_widget.dart';

class ImagePortionEditProfile extends StatelessWidget {
  const ImagePortionEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final userController = Provider.of<GetUserData>(context).userModel;
    return SizedBox(
      height: 90,
      width: 90,
      child: Stack(
        children: [
          if (imageController.selectedImage == null && userController.image == "")
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryGrey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/images/person.png', color: AppColors.primaryGrey),
              ),
            )
          else if (imageController.selectedImage == null && userController.image != "")
            Container(
              height: 80,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: userController.image!,
                  placeholder: (context, url) => spinKit2,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: 80,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(imageController.selectedImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Positioned(
            bottom: imageController.selectedImage == null && userController.image == "" ? 5 : 15,
            right: imageController.selectedImage == null && userController.image == "" ? 5 : 3,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: AppColors.primaryGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  if (imageController.selectedImage == null) {
                    uploadPhotoOptionWidget(
                      context: context,
                      onCameraClicked: () {
                        imageController.getUserImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                      onGalleryClicked: () {
                        imageController.getUserImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    UserProfileServices.updateProfilePic(
                      context,
                      imageController.selectedImage ?? userController.image,
                    );
                    imageController.deleteUploadPhoto();
                  }
                },
                child: imageController.selectedImage == null
                    ? Icon(Icons.edit, size: 15, color: AppColors.primaryWhite)
                    : Icon(Icons.check, size: 15, color: AppColors.primaryWhite),
              ),
            ),
          )
        ],
      ),
    );
  }
}
