// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:people_talk/controllers/group_chat_controller.dart';
import 'package:people_talk/controllers/image_controller.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/models/user_model.dart';
import 'package:people_talk/themes/app_text_style.dart';
import 'package:people_talk/widgets/buttons.dart';
import 'package:people_talk/widgets/custom_text_input.dart';
import 'package:provider/provider.dart';

class GroupNameAndPicSelectionScreen extends StatefulWidget {
  final List<String> groupId;
  const GroupNameAndPicSelectionScreen({super.key, required this.groupId});

  @override
  State<GroupNameAndPicSelectionScreen> createState() => _GroupNameAndPicSelectionScreenState();
}

class _GroupNameAndPicSelectionScreenState extends State<GroupNameAndPicSelectionScreen> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupBioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final loadingController = Provider.of<LoadingController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Information", style: AppTextStyle.h1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              imageController.selectedImage == null
                  ? Center(
                      child: CircleAvatar(
                        radius: 45,
                        child: InkWell(
                          onTap: () {
                            imageController.getUserImage(ImageSource.camera);
                          },
                          child: const Icon(Icons.image),
                        ),
                      ),
                    )
                  : Center(
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: FileImage(
                          imageController.selectedImage!,
                        ),
                      ),
                    ),
              const SizedBox(height: 25),
              Text("Group Name (*)", style: AppTextStyle.h1),
              const SizedBox(height: 10),
              CustomTextInput(
                hintText: 'Group Name',
                controller: groupNameController,
                validator: (v) {},
              ),
              const SizedBox(height: 25),
              Text("Group Bio (*)", style: AppTextStyle.h1),
              const SizedBox(height: 10),
              CustomTextInput(
                hintText: 'Group Bio',
                controller: groupBioController,
                validator: (v) {},
              ),
              const SizedBox(height: 25),
              Text("Selected Users", style: AppTextStyle.h1),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.2,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.groupId.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(widget.groupId[index]).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          UserModel userModel = UserModel.fromDoc(snapshot.data!);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(userModel.image!),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  userModel.username!,
                                  style: AppTextStyle.h1.copyWith(
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
              const SizedBox(height: 30),
              loadingController.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PrimaryButton(
                      onPressed: () {
                        GroupChatController().creatingGroup(
                          context: context,
                          groupImage: imageController.selectedImage!,
                          groupName: groupNameController.text,
                          groupBio: groupBioController.text,
                          ids: widget.groupId,
                        );
                        imageController.deleteUploadPhoto();
                      },
                      title: "Create",
                    )
            ],
          ),
        ),
      ),
    );
  }
}
