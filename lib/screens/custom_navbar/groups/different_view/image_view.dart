import 'dart:io';

import 'package:flutter/material.dart';
import 'package:people_talk/services/group_chat_services.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../controllers/image_controller.dart';
import '../../../../controllers/loading_controller.dart';
import '../../../../models/group_creating_model.dart';

class SendingAndViewImageInGroup extends StatefulWidget {
  final GroupCreatingModel groupChatModel;
  const SendingAndViewImageInGroup({super.key, required this.groupChatModel});

  @override
  _SendingAndViewImageInGroupState createState() => _SendingAndViewImageInGroupState();
}

class _SendingAndViewImageInGroupState extends State<SendingAndViewImageInGroup> {
  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final loadingController = Provider.of<LoadingController>(context);

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(Icons.close, color: AppColors.primaryWhite),
            onPressed: () {
              imageController.deleteUploadPhoto();
            },
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: loadingController.isLoading
                ? CircularProgressIndicator(
                    color: Colors.teal.withOpacity(0.5),
                  )
                : const Icon(Icons.send),
            onPressed: () async {
              if (!loadingController.isLoading) {
                loadingController.setLoading(true);
                try {
                  await GroupChatServices().sendingImagesInGroup(
                    context: context,
                    docId: widget.groupChatModel.groupId!,
                    imageFile: imageController.selectedImage!,
                  );
                  setState(() {
                    loadingController.setLoading(false);
                    imageController.deleteUploadPhoto();
                  });
                } catch (e) {
                  loadingController.setLoading(false);
                }
              }
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Send Image", style: AppTextStyle.h1),
      ),
      body: imageController.selectedImage != null
          ? Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(imageController.selectedImage!.path)),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
