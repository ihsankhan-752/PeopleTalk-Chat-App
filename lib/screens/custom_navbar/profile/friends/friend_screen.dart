import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/app_colors.dart';
import 'package:people_talk/constants/app_text_style.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:people_talk/models/user_model.dart';
import 'package:people_talk/screens/custom_navbar/profile/friends/add_friends_screen.dart';
import 'package:people_talk/screens/custom_navbar/profile/friends/friend_request_screen.dart';
import 'package:people_talk/screens/custom_navbar/profile/friends/widgets/user_profile_card_widget.dart';
import 'package:people_talk/widgets/search_text_input.dart';
import 'package:provider/provider.dart';

import '../../messages/chat_main_screen.dart';

class FriendScreen extends StatelessWidget {
  const FriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<GetUserData>(context).userModel;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Get.to(() => const AddFriendsScreen());
        },
        child: Icon(Icons.add, color: AppColors.primaryWhite),
      ),
      appBar: AppBar(
        title: const Text("Friends"),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => const FriendRequestScreen());
            },
            child: const Text(
              "Friend requests",
              style: TextStyle(color: Colors.indigoAccent, fontSize: 14),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchTextInput(),
            Expanded(
                child: StreamBuilder(
              stream: userController.friendsList != null && userController.friendsList!.isNotEmpty
                  ? FirebaseFirestore.instance
                      .collection('users')
                      .where(FieldPath.documentId, whereIn: userController.friendsList!)
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
                      "No Friends Found",
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
                      onPressed: () {
                        Get.to(() => ChatMainScreen(
                              userId: userModel.userId!,
                              username: userModel.username!,
                              userImage: userModel.image!,
                            ));
                      },
                      title: userModel.username,
                      titleFirstLetter: userModel.username![0],
                      subTitle: userModel.contact.toString(),
                    );
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
