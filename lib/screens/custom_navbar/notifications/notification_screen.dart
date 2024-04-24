import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:people_talk/constants/loading_indicator.dart';
import 'package:people_talk/models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/app_colors.dart';
import '../../../constants/app_text_style.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        SafeArea(
          child: Center(child: Text("Notifications", style: AppTextStyle.main.copyWith(fontSize: 18, letterSpacing: 1.5))),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('toUserId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: spinKit2,
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset('assets/images/no_notification.png', fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            "No Notification Found!",
                            style: AppTextStyle.h1.copyWith(
                              fontSize: 18,
                              color: AppColors.primaryGrey,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    NotificationModel notificationModel = NotificationModel.fromMap(snapshot.data!.docs[index]);
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            radius: 30,
                            child: Center(
                              child: Icon(Icons.notifications_on_sharp, color: AppColors.primaryWhite),
                            ),
                          ),
                          title: Text(
                            notificationModel.notificationTitle!,
                            style: AppTextStyle.h1.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            notificationModel.notificationBody!,
                            style: AppTextStyle.h1.copyWith(
                              fontSize: 12,
                              color: AppColors.primaryGrey,
                            ),
                          ),
                          trailing: Text(
                            timeago.format(notificationModel.createdAt!),
                            style: AppTextStyle.h1.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Divider(thickness: 0.2, height: 0.1),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
