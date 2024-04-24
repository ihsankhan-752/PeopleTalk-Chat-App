import 'dart:io';

import 'package:flutter/material.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/services/chat_services.dart';
import 'package:provider/provider.dart';

import '../../../../../controllers/image_controller.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_style.dart';

class SendingAndViewImage extends StatefulWidget {
  final String userId;
  final String docId;
  const SendingAndViewImage({super.key, required this.userId, required this.docId});

  @override
  _SendingAndViewImageState createState() => _SendingAndViewImageState();
}

class _SendingAndViewImageState extends State<SendingAndViewImage> {
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
                  await ChatServices().sendImageInChat(
                    context: context,
                    image: imageController.selectedImage,
                    userId: widget.userId,
                    docId: widget.docId,
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
