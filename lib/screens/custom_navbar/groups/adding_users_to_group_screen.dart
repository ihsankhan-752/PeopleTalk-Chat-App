import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/screens/custom_navbar/groups/group_pic_and_bio_adding_screen.dart';
import 'package:people_talk/widgets/buttons.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_text_style.dart';
import '../../../controllers/get_user_data.dart';
import '../../../models/user_model.dart';
import '../../../widgets/search_text_input.dart';
import '../profile/friends/widgets/user_profile_card_widget.dart';

class AddingUsersToGroupScreen extends StatefulWidget {
  const AddingUsersToGroupScreen({super.key});

  @override
  State<AddingUsersToGroupScreen> createState() => _AddingUsersToGroupScreenState();
}

class _AddingUsersToGroupScreenState extends State<AddingUsersToGroupScreen> {
  List<String> userIds = [FirebaseAuth.instance.currentUser!.uid];

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<GetUserData>(context).userModel;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: PrimaryButton(
          onPressed: () {
            Get.to(() => GroupPicAndBioAddingScreen(userIds: userIds));
          },
          title: "Next",
        ),
      ),
      appBar: AppBar(
        title: const Text("Add Friends"),
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
                      trailingWidget: SuggestionButton(
                        width: 100,
                        onPressed: () {
                          if (userIds.contains(userModel.userId)) {
                            setState(() {
                              userIds.remove(userModel.userId);
                            });
                          } else {
                            setState(() {
                              userIds.add(userModel.userId!);
                            });
                          }
                        },
                        bgColor: AppColors.primaryBlack,
                        title: userIds.contains(userModel.userId) ? "Remove" : "Add",
                      ),
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
