import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/app_text_style.dart';
import 'package:people_talk/constants/loading_indicator.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/models/group_creating_model.dart';
import 'package:people_talk/models/user_model.dart';
import 'package:people_talk/widgets/buttons.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/app_colors.dart';
import '../../../services/group_chat_services.dart';
import '../../../widgets/dialogs.dart';

class GroupInformation extends StatelessWidget {
  final GroupCreatingModel groupCreatingModel;
  const GroupInformation({super.key, required this.groupCreatingModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupCreatingModel.groupName!, style: AppTextStyle.h1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(groupCreatingModel.groupImage!),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Group Information",
              style: AppTextStyle.h1.copyWith(
                color: AppColors.primaryGrey,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryGrey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Created At: ${timeago.format(groupCreatingModel.groupCreatedAt!)}", style: AppTextStyle.h1),
                    const SizedBox(height: 20),
                    Text("Group Bio: ${groupCreatingModel.groupBio}", style: AppTextStyle.h1),
                    const SizedBox(height: 20),
                    Text("Created By: ${groupCreatingModel.groupAdmin}", style: AppTextStyle.h1),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text("Group Members",
                style: AppTextStyle.h1.copyWith(
                  color: AppColors.primaryGrey,
                )),
            const SizedBox(height: 15),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.2,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where(FieldPath.documentId, whereIn: groupCreatingModel.ids)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      UserModel userModel = UserModel.fromDoc(snapshot.data!.docs[index]);
                      if (groupCreatingModel.groupCreatorId == userModel.userId) {
                        return const SizedBox();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: SizedBox(
                            width: 150,
                            child: Card(
                              color: AppColors.primaryColor.withOpacity(0.45),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  userModel.image == ""
                                      ? CircleAvatar(
                                          backgroundColor: AppColors.primaryBlack,
                                          radius: 35,
                                          child: Center(
                                            child: Text(
                                              userModel.username![0].toUpperCase(),
                                              style: AppTextStyle.h1.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 35,
                                          backgroundImage: NetworkImage(userModel.image!),
                                        ),
                                  const SizedBox(height: 05),
                                  Text(userModel.username!,
                                      style: AppTextStyle.h1.copyWith(
                                        fontSize: 14,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Consumer<LoadingController>(builder: (context, loadingController, child) {
          return loadingController.isLoading
              ? SizedBox(
                  height: 60,
                  width: Get.width,
                  child: Center(
                    child: spinKit2,
                  ),
                )
              : PrimaryButton(
                  onPressed: () {
                    if (groupCreatingModel.groupCreatorId != FirebaseAuth.instance.currentUser!.uid) {
                      showCustomMsg("You are not Admin");
                    } else {
                      customAlertDialog(
                        context: context,
                        content: "Are you sure to delete this Group?",
                        onPressed: () {
                          GroupChatServices.deleteGroup(context, groupCreatingModel.groupId!);
                        },
                      );
                    }
                  },
                  title: 'Delete Group',
                  btnColor: Colors.red,
                );
        }),
      ),
    );
  }
}
