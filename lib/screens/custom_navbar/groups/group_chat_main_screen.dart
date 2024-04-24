// ignore_for_file: curly_braces_in_flow_control_structures, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:people_talk/controllers/file_controller.dart';
import 'package:people_talk/controllers/image_controller.dart';
import 'package:people_talk/models/group_creating_model.dart';
import 'package:provider/provider.dart';

import 'different_view/file_view.dart';
import 'different_view/image_view.dart';
import 'different_view/text_view.dart';

class GroupChatMainScreen extends StatefulWidget {
  final GroupCreatingModel groupModel;
  const GroupChatMainScreen({super.key, required this.groupModel});

  @override
  State<GroupChatMainScreen> createState() => _GroupChatMainScreenState();
}

class _GroupChatMainScreenState extends State<GroupChatMainScreen> {
  TextEditingController msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final fileController = Provider.of<FileController>(context);

    return imageController.selectedImage == null && fileController.pdf == null
        ? SendAndDisplayTextViewInGroup(
            groupModel: widget.groupModel,
          )
        : fileController.pdf == null
            ? SendingAndViewImageInGroup(groupChatModel: widget.groupModel)
            : SendingAndViewFileInGroup(groupCreatingModel: widget.groupModel);
  }
}
