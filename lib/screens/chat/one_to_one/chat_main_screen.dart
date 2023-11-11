import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:people_talk/controllers/file_controller.dart';
import 'package:people_talk/controllers/image_controller.dart';
import 'package:people_talk/utils/text_controller.dart';
import 'package:provider/provider.dart';

import 'different_views/display_text_view.dart';
import 'different_views/sending_and_view_file_tab.dart';
import 'different_views/sending_image_view.dart';

class ChatMainScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String userImage;
  const ChatMainScreen({
    super.key,
    required this.userId,
    required this.username,
    required this.userImage,
  });

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  AppTextControllers appTextControllers = AppTextControllers();
  String docId = '';
  var myId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    if (myId.hashCode > widget.userId.hashCode) {
      docId = myId + widget.userId;
    } else {
      docId = widget.userId + myId;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);
    var imageController = Provider.of<ImageController>(context);

    return imageController.selectedImage == null && fileController.pdf == null
        ? SendAndDisplayTestView(
            docId: docId,
            userId: widget.userId,
            username: widget.username,
            userImage: widget.userImage,
          )
        : fileController.pdf == null
            ? SendingAndViewImage(docId: docId, userId: widget.userId)
            : SendingAndViewFile(userId: widget.userId, docId: docId);
  }
}
