import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/screens/chat/group_chat/group_chat_main_screen.dart';

import '../../../models/group_creating_model.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_style.dart';

class UserGroupList extends StatelessWidget {
  const UserGroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groupChat')
            .where('uids', arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Group Found!", style: AppTextStyle.h1),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              GroupCreatingModel groupModel = GroupCreatingModel.fromDoc(snapshot.data!.docs[index]);
              return InkWell(
                onTap: () {
                  Get.to(
                    () => GroupChatMainScreen(
                      groupModel: groupModel,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(groupModel.groupImage!),
                      ),
                      title: Text(groupModel.groupName!, style: AppTextStyle.h1),
                      subtitle: Text(
                        groupModel.lastMsg == "" ? "${groupModel.groupAdmin} Created Group" : groupModel.lastMsg!,
                        style: AppTextStyle.h1.copyWith(
                          fontWeight: FontWeight.normal,
                          color: AppColors.primaryGrey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Divider(height: 0.1, thickness: 0.7, color: Colors.teal.withOpacity(0.5)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
