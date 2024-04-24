import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/app_colors.dart';
import 'package:people_talk/models/group_creating_model.dart';
import 'package:people_talk/screens/custom_navbar/groups/adding_users_to_group_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/app_text_style.dart';
import '../../../constants/loading_indicator.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/search_text_input.dart';
import '../messages/widgets/no_friend_found_for_chat_widget.dart';
import 'group_chat_main_screen.dart';

class GroupChatFrontScreen extends StatefulWidget {
  const GroupChatFrontScreen({super.key});

  @override
  State<GroupChatFrontScreen> createState() => _GroupChatFrontScreenState();
}

class _GroupChatFrontScreenState extends State<GroupChatFrontScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Groups", style: AppTextStyle.main.copyWith(fontSize: 18, letterSpacing: 1.5)),
                  AddFriendOrGroupBtn(
                    onPressed: () {
                      Get.to(() => const AddingUsersToGroupScreen());
                    },
                    title: "Make Group",
                    icon: Icons.group_add,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchTextInput(
                  controller: _searchController,
                  onChanged: (v) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: Get.height * 0.7,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('groupChat')
                        .where('uids', arrayContains: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: spinKit2,
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return const NoFriendFoundForChatWidget(
                          image: "assets/images/nogroupchat.png",
                          title: "No Groups found\nfor chat",
                        );
                        ;
                      }
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          GroupCreatingModel groupCreatingModel = GroupCreatingModel.fromDoc(snapshot.data!.docs[index]);

                          if (_searchController.text.isEmpty ||
                              groupCreatingModel.groupName.toString().toLowerCase().contains(_searchController.text)) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => GroupChatMainScreen(groupModel: groupCreatingModel));
                                    },
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(groupCreatingModel.groupImage!),
                                      ),
                                      title: Text(groupCreatingModel.groupName!, style: AppTextStyle.h1),
                                      subtitle: Text(
                                        groupCreatingModel.lastMsg == "" ? "No Msg Sent yet" : groupCreatingModel.lastMsg!,
                                        style: AppTextStyle.h1.copyWith(
                                          fontSize: 12,
                                          color: AppColors.primaryGrey,
                                        ),
                                      ),
                                      trailing: Text(
                                        timeago.format(groupCreatingModel.groupCreatedAt!),
                                        style: AppTextStyle.h1.copyWith(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(color: AppColors.primaryColor.withOpacity(0.8)),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
