import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../themes/app_text_style.dart';
import '../../chat/one_to_one/chat_main_screen.dart';
import '../../chat/widgets/user_profile_card_with_last_msg.dart';

class UserChatList extends StatelessWidget {
  const UserChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .where('uids', arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.teal.withOpacity(0.5)),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Users Found For Chat!",
                  style: AppTextStyle.h1.copyWith(
                    color: Colors.teal.withOpacity(0.5),
                  )),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              getUserId() {
                if (data['uids'][0] == FirebaseAuth.instance.currentUser!.uid) {
                  return data['uids'][1];
                } else {
                  return data['uids'][0];
                }
              }

              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(getUserId()).snapshots(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  UserModel userModel = UserModel.fromDoc(userSnap.data!);
                  return UserProfileCardWithLastMsg(
                    onPressed: () {
                      Get.to(
                        () => ChatMainScreen(
                          userId: userModel.userId!,
                          username: userModel.username!,
                          userImage: userModel.image!,
                        ),
                      );
                    },
                    userModel: userModel,
                    msg: data['msg'],
                    createdAt: data['createdAt'].toDate(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
