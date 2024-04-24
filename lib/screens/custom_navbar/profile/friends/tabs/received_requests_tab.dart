import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:people_talk/services/friends_services.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_style.dart';
import '../../../../../models/user_model.dart';
import '../../../../../services/notification_services.dart';
import '../../../../../widgets/buttons.dart';
import '../widgets/user_profile_card_widget.dart';

class ReceivedRequestsTab extends StatelessWidget {
  const ReceivedRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<GetUserData>(context).userModel;
    return Expanded(
      child: StreamBuilder(
        stream: userController.receivedRequestList != null && userController.receivedRequestList!.isNotEmpty
            ? FirebaseFirestore.instance
                .collection('users')
                .where(FieldPath.documentId, whereIn: userController.receivedRequestList)
                .snapshots()
            : const Stream.empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: AppTextStyle.h1.copyWith(
                  color: Colors.red,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Requests Found",
                style: AppTextStyle.h1.copyWith(
                  color: AppColors.primaryGrey,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              UserModel userModel = UserModel.fromDoc(snapshot.data!.docs[index]);
              return UserProfileCardWidget(
                title: userModel.username,
                titleFirstLetter: userModel.username![0],
                subTitle: userModel.contact.toString(),
                bottomWidget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SuggestionButton(
                        onPressed: () async {
                          FriendsServices.acceptFriendRequest(context, userModel.userId!);
                          await NotificationServices().sendNotificationToSpecificUser(
                            title: "Friend Request Accepted",
                            body: "${userController.username} accept your friend request",
                            userId: userModel.userId!,
                          );

                          await NotificationServices.addNotificationInDb(
                            notificationTitle: "Friend Request Accepted",
                            notificationBody: "${userController.username} accept your friend request",
                            toUserId: userModel.userId!,
                          );
                        },
                        title: "Approve",
                        bgColor: Colors.green,
                        width: Get.width * 0.4,
                      ),
                      SuggestionButton(
                        onPressed: () async {
                          FriendsServices.rejectComingRequest(context, userModel.userId!);
                          await NotificationServices().sendNotificationToSpecificUser(
                            title: "Friend Request Rejected",
                            body: "${userController.username} reject your friend request",
                            userId: userModel.userId!,
                          );

                          await NotificationServices.addNotificationInDb(
                            notificationTitle: "Friend Request Rejected",
                            notificationBody: "${userController.username} reject your friend request",
                            toUserId: userModel.userId!,
                          );
                        },
                        title: "Reject",
                        bgColor: Colors.red,
                        width: Get.width * 0.4,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
