import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:people_talk/constants/loading_indicator.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_style.dart';
import '../../../../../models/user_model.dart';
import '../../../../../services/friends_services.dart';
import '../../../../../services/notification_services.dart';

class SearchResultWidget extends StatelessWidget {
  final UserModel userController;
  const SearchResultWidget({super.key, required this.userController});

  @override
  Widget build(BuildContext context) {
    final myProfileController = Provider.of<GetUserData>(context).userModel;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryBlack,
            radius: 30,
            child: Center(
              child: Text(
                userController.username![0].toUpperCase(),
                style: AppTextStyle.h1.copyWith(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          title: Text(
            userController.username!,
            style: AppTextStyle.h1.copyWith(
              fontSize: 16,
            ),
          ),
          subtitle: SizedBox(
            width: Get.width * 0.2,
            child: Row(
              children: [
                Text(
                  "Since: ",
                  style: AppTextStyle.h1.copyWith(
                    color: AppColors.primaryGrey,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('dd MMMM yyyy').format(userController.memberSince!),
                  style: AppTextStyle.h1.copyWith(
                    fontSize: 12,
                    color: AppColors.primaryGrey,
                  ),
                ),
              ],
            ),
          ),
          trailing: SizedBox(
            width: 80,
            child: Consumer<LoadingController>(builder: (context, loadingController, child) {
              if (myProfileController.friendsList!.contains(userController.userId) ||
                  myProfileController.sendRequestList!.contains(userController.userId) ||
                  myProfileController.receivedRequestList!.contains(userController.userId)) {
                return const SizedBox();
              } else {
                return loadingController.isLoading
                    ? Center(
                        child: spinKit2,
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            )),
                        child: Text(
                          "Add",
                          style: AppTextStyle.h1.copyWith(fontSize: 12),
                        ),
                        onPressed: () async {
                          FriendsServices.addFriend(context, userController.userId!);
                          await NotificationServices().sendNotificationToSpecificUser(
                            title: "Friend Request",
                            body: "You have received a new friend request",
                            userId: userController.userId!,
                          );

                          await NotificationServices.addNotificationInDb(
                            notificationTitle: "Friend Request",
                            notificationBody: "You have a New Friend Request",
                            toUserId: userController.userId!,
                          );
                        },
                      );
              }
            }),
          ),
        ),
      ),
    );
  }
}
