import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/app_colors.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/screens/custom_navbar/profile/widgets/image_portion_edit_profile.dart';
import 'package:people_talk/services/user_profile_services.dart';
import 'package:people_talk/widgets/buttons.dart';
import 'package:people_talk/widgets/custom_text_input.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_text_style.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<GetUserData>(context).userModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightPrimaryColor,
        title: Text("Edit Profile", style: AppTextStyle.main.copyWith(fontSize: 18, letterSpacing: 1.5)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const ImagePortionEditProfile(),
              Container(
                width: Get.width,
                margin: const EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryBlack,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DISPLAY NAME",
                        style: AppTextStyle.h1.copyWith(
                          fontSize: 12,
                          letterSpacing: 1.2,
                          color: AppColors.primaryGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextInput(
                        hintText: userController.username!,
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "CONTACT",
                        style: AppTextStyle.h1.copyWith(
                          fontSize: 12,
                          letterSpacing: 1.2,
                          color: AppColors.primaryGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextInput(
                        inputType: TextInputType.number,
                        hintText: userController.contact!.toString(),
                        controller: _contactController,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "ABOUT ME",
                        style: AppTextStyle.h1.copyWith(
                          fontSize: 12,
                          letterSpacing: 1.2,
                          color: AppColors.primaryGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextInput(
                        hintText: userController.bio == "" ? "Enter Something about yourself" : userController.bio!,
                        controller: _bioController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 40),
                      Consumer<LoadingController>(builder: (context, loadingController, child) {
                        return loadingController.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : PrimaryButton(
                                title: "SAVE",
                                onPressed: () {
                                  UserProfileServices().updateProfile(
                                    context: context,
                                    username:
                                        _usernameController.text.isEmpty ? userController.username : _usernameController.text,
                                    bio: _bioController.text.isEmpty ? userController.bio : _bioController.text,
                                    contact: _contactController.text.isEmpty
                                        ? userController.contact
                                        : int.tryParse(_contactController.text),
                                  );
                                  setState(() {
                                    _contactController.clear();
                                    _bioController.clear();
                                    _usernameController.clear();
                                  });
                                },
                              );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
