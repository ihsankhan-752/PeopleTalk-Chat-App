import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:people_talk/constants/app_colors.dart';
import 'package:people_talk/constants/loading_indicator.dart';
import 'package:people_talk/services/group_chat_services.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:people_talk/widgets/upload_photo_option_widget.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_text_style.dart';
import '../../../controllers/image_controller.dart';
import '../../../controllers/loading_controller.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/custom_text_input.dart';

class GroupPicAndBioAddingScreen extends StatefulWidget {
  final List<String> userIds;

  const GroupPicAndBioAddingScreen({super.key, required this.userIds});

  @override
  State<GroupPicAndBioAddingScreen> createState() => _GroupPicAndBioAddingScreenState();
}

class _GroupPicAndBioAddingScreenState extends State<GroupPicAndBioAddingScreen> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupBioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(widget.userIds);
    final imageController = Provider.of<ImageController>(context);
    final loadingController = Provider.of<LoadingController>(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: loadingController.isLoading
            ? SizedBox(
                height: 50,
                width: Get.width,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: spinKit2,
                  ),
                ),
              )
            : PrimaryButton(
                onPressed: () {
                  if (imageController.selectedImage == null) {
                    showCustomMsg("Select Image First");
                  } else {
                    GroupChatServices().creatingGroup(
                      context: context,
                      groupImage: imageController.selectedImage!,
                      groupName: groupNameController.text,
                      groupBio: groupBioController.text,
                      ids: widget.userIds,
                    );
                    imageController.deleteUploadPhoto();
                    setState(() {
                      groupNameController.clear();
                      groupBioController.clear();
                    });
                  }
                },
                title: "Create",
              ),
      ),
      appBar: AppBar(
        title: Text("Group Information", style: AppTextStyle.h1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              imageController.selectedImage == null
                  ? Center(
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryBlack,
                        radius: 45,
                        child: InkWell(
                          onTap: () {
                            uploadPhotoOptionWidget(
                              context: context,
                              onCameraClicked: () {
                                Get.back();
                                imageController.getUserImage(ImageSource.camera);
                              },
                              onGalleryClicked: () {
                                Get.back();

                                imageController.getUserImage(ImageSource.gallery);
                              },
                            );
                          },
                          child: Icon(Icons.image, size: 25, color: AppColors.primaryWhite),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Group Name", style: AppTextStyle.h1),
                  const SizedBox(height: 10),
                  CustomTextInput(
                    hintText: 'Group Name',
                    controller: groupNameController,
                  ),
                  const SizedBox(height: 25),
                  Text("Group Bio", style: AppTextStyle.h1),
                  const SizedBox(height: 10),
                  CustomTextInput(
                    hintText: "Description",
                    controller: groupBioController,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
