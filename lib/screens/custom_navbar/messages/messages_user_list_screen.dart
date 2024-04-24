import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/app_text_style.dart';
import 'package:people_talk/constants/loading_indicator.dart';
import 'package:people_talk/models/user_model.dart';
import 'package:people_talk/screens/custom_navbar/messages/widgets/no_friend_found_for_chat_widget.dart';
import 'package:people_talk/screens/custom_navbar/messages/widgets/user_chat_card.dart';
import 'package:people_talk/screens/custom_navbar/profile/friends/add_friends_screen.dart';
import 'package:people_talk/widgets/search_text_input.dart';

import '../../../widgets/buttons.dart';

class MessagesUserChatListScreen extends StatefulWidget {
  const MessagesUserChatListScreen({super.key});

  @override
  State<MessagesUserChatListScreen> createState() => _MessagesUserChatListScreenState();
}

class _MessagesUserChatListScreenState extends State<MessagesUserChatListScreen> {
  final TextEditingController _userSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Messages", style: AppTextStyle.main.copyWith(fontSize: 18, letterSpacing: 1.5)),
                    AddFriendOrGroupBtn(
                      onPressed: () {
                        Get.to(() => const AddFriendsScreen());
                      },
                      title: "Add Friends",
                      icon: Icons.person_add_alt_rounded,
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
                    controller: _userSearchController,
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.7,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chat')
                          .where('uids', arrayContains: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: spinKit2,
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return const NoFriendFoundForChatWidget(
                            image: "assets/images/nouser.png",
                            title: "No user found\n for chat",
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            String otherUserId = snapshot.data!.docs[index]['uids']
                                .firstWhere((id) => id != FirebaseAuth.instance.currentUser!.uid);

                            return StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('users').doc(otherUserId).snapshots(),
                                builder: (context, snap) {
                                  if (!snap.hasData) {
                                    return Center(
                                      child: spinKit2,
                                    );
                                  }

                                  UserModel userModel = UserModel.fromDoc(snap.data!);

                                  if (_userSearchController.text.isEmpty ||
                                      userModel.username.toString().toLowerCase().contains(_userSearchController.text)) {
                                    return UserChatCard(
                                      userModel: userModel,
                                      msg: snapshot.data!.docs[index]['msg'],
                                      msgTime: snapshot.data!.docs[index]['createdAt'].toDate(),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                });
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
      ),
    );
  }
}
