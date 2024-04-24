import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:people_talk/screens/custom_navbar/profile/change_password_screen.dart';
import 'package:people_talk/screens/custom_navbar/profile/edit_profile.dart';
import 'package:people_talk/screens/custom_navbar/profile/friends/friend_screen.dart';
import 'package:people_talk/screens/custom_navbar/profile/widgets/custom_profile_tab.dart';
import 'package:people_talk/screens/custom_navbar/profile/widgets/profile_image_widget.dart';
import 'package:people_talk/services/auth_services.dart';
import 'package:people_talk/widgets/dialogs.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<GetUserData>(context).userModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        SafeArea(
          child: Center(child: Text("My Profile", style: AppTextStyle.main.copyWith(fontSize: 18, letterSpacing: 1.5))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileImageWidget(),
              const SizedBox(height: 20),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userController.username!.toUpperCase(),
                        style: AppTextStyle.h1.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Member Since",
                        style: AppTextStyle.h1.copyWith(
                          color: AppColors.primaryGrey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('dd MMMM yyyy').format(userController.memberSince!),
                        style: AppTextStyle.h1.copyWith(
                          fontSize: 16,
                          color: AppColors.primaryGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomProfileTab(
                onPressed: () {
                  Get.to(() => const EditProfileScreen());
                },
                title: "Edit Profile",
                image: "assets/images/edit.png",
              ),
              CustomProfileTab(
                onPressed: () {
                  Get.to(() => const FriendScreen());
                },
                title: "Friends",
                image: "assets/images/friends.png",
              ),
              CustomProfileTab(
                  onPressed: () {
                    Get.to(() => const ChangePasswordScreen());
                  },
                  title: "Change Password",
                  image: "assets/images/change.png"),
              CustomProfileTab(
                onPressed: () {
                  customAlertDialog(
                    context: context,
                    content: "Are you sure to LogOut?",
                    onPressed: () {
                      AuthServices().logOut();
                    },
                  );
                },
                title: "LogOut",
                image: "assets/images/logout.png",
              ),
              CustomProfileTab(
                onPressed: () {
                  customAlertDialog(
                    context: context,
                    content: "Are you sure to delete you Account?",
                    onPressed: () {
                      AuthServices().deleteAccount(context);
                    },
                  );
                },
                title: "Delete Account",
                textColor: Colors.red,
                iconColor: Colors.red,
                image: "assets/images/delete.png",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
