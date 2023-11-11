import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:people_talk/controllers/image_controller.dart';
import 'package:people_talk/services/auth_services.dart';
import 'package:people_talk/utils/text_controller.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_text_style.dart';
import '../../utils/app_text.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_text_input.dart';
import '../../widgets/logo_widget.dart';

class UserInformationEnteringScreen extends StatelessWidget {
  const UserInformationEnteringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final authServices = Provider.of<AuthServices>(context);
    AppTextControllers appTextControllers = AppTextControllers();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              const LogoWidget(),
              const SizedBox(height: 35),
              Text(
                "${AppText.image} *",
                style: AppTextStyle.h1.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 5),
              if (imageController.selectedImage == null)
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: GestureDetector(
                      onTap: () {
                        imageController.getUserImage(ImageSource.gallery);
                      },
                      child: const Icon(Icons.photo),
                    ),
                  ),
                )
              else
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(File(imageController.selectedImage!.path)),
                  ),
                ),
              const SizedBox(height: 35),
              Text(
                "${AppText.bio} *",
                style: AppTextStyle.h1.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 5),
              CustomTextInput(
                hintText: AppText.bio,
                controller: appTextControllers.bioController,
                validator: (v) {},
              ),
              const SizedBox(height: 30),
              authServices.isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: AppColors.mainColor),
                    )
                  : PrimaryButton(
                      title: AppText.save,
                      onPressed: () {
                        authServices.updateBioAndImageForProfile(
                          imageController.selectedImage!,
                          appTextControllers.bioController.text,
                        );
                      },
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
