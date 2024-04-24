import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/screens/custom_navbar/custom_navbar.dart';
import 'package:people_talk/services/storage_services.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/group_chat_model.dart';
import '../models/group_creating_model.dart';

class GroupChatServices {
  creatingGroup({
    required BuildContext context,
    File? groupImage,
    required String groupName,
    required String groupBio,
    required List<String> ids,
  }) async {
    if (groupImage == null) {
      showCustomMsg("Group Image Required");
    } else if (groupName.isEmpty) {
      showCustomMsg("Group Name Required");
    } else if (groupBio.isEmpty) {
      showCustomMsg("Group Bio Required");
    } else {
      try {
        var groupId = const Uuid().v4();

        Provider.of<LoadingController>(context, listen: false).setLoading(true);

        DocumentSnapshot snap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
        String imageUrl = await StorageServices().uploadImageToDb(groupImage);

        GroupCreatingModel groupCreatingModel = GroupCreatingModel(
          groupId: groupId,
          groupCreatedAt: DateTime.now(),
          groupName: groupName,
          groupImage: imageUrl,
          groupCreatorId: FirebaseAuth.instance.currentUser!.uid,
          groupBio: groupBio,
          groupAdmin: snap['username'],
          ids: ids,
          lastMsg: "",
        );

        await FirebaseFirestore.instance.collection('groupChat').doc(groupId).set(groupCreatingModel.toMap());
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        Get.offAll(() => const CustomNavBar());
        showCustomMsg("Group Is Created Successfully");
      } on FirebaseException catch (e) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showCustomMsg(e.message!);
      }
    }
  }

  sendingTextMsgInGroup({
    required BuildContext context,
    required String docId,
    required String msg,
  }) async {
    if (msg.isEmpty) {
      showCustomMsg("Type SomeThing");
    } else {
      try {
        Provider.of<LoadingController>(context, listen: false).setLoading(true);

        DocumentSnapshot snap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

        GroupChatModel groupChatModel = GroupChatModel(
          msg: msg,
          image: '',
          audioFile: '',
          createdAt: DateTime.now(),
          file: "",
          senderId: snap['userId'],
          senderImage: snap['image'],
          senderName: snap['username'],
        );

        await FirebaseFirestore.instance.collection('groupChat').doc(docId).collection('messages').add(groupChatModel.toMap());
        await FirebaseFirestore.instance.collection('groupChat').doc(docId).update({
          'lastMsg': msg,
        });
        if (!context.mounted) return;

        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        FocusScope.of(context).unfocus();
      } on FirebaseException catch (err) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showCustomMsg(err.message!);
      }
    }
  }

  sendingImagesInGroup({
    required BuildContext context,
    required String docId,
    required File imageFile,
  }) async {
    if (imageFile == null) {
      showCustomMsg("Type SomeThing");
    } else {
      try {
        Provider.of<LoadingController>(context, listen: false).setLoading(true);

        DocumentSnapshot snap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

        String imageUrl = await StorageServices().uploadImageToDb(imageFile);

        GroupChatModel groupChatModel = GroupChatModel(
          msg: '',
          image: imageUrl,
          audioFile: '',
          createdAt: DateTime.now(),
          file: "",
          senderId: snap['userId'],
          senderImage: snap['image'],
          senderName: snap['username'],
        );

        await FirebaseFirestore.instance.collection('groupChat').doc(docId).collection('messages').add(groupChatModel.toMap());
        await FirebaseFirestore.instance.collection('groupChat').doc(docId).update({
          'lastMsg': 'You Received an Image',
        });
        if (!context.mounted) return;

        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        FocusScope.of(context).unfocus();
      } on FirebaseException catch (err) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showCustomMsg(err.message!);
      }
    }
  }

  sendingFilesInGroup({
    required BuildContext context,
    required String docId,
    required File file,
  }) async {
    if (file == null) {
      showCustomMsg("Type SomeThing");
    } else {
      try {
        Provider.of<LoadingController>(context, listen: false).setLoading(true);

        DocumentSnapshot snap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

        String fileLink = await StorageServices().uploadImageToDb(file);

        GroupChatModel groupChatModel = GroupChatModel(
          msg: '',
          image: '',
          audioFile: '',
          createdAt: DateTime.now(),
          file: fileLink,
          senderId: snap['userId'],
          senderImage: snap['image'],
          senderName: snap['username'],
        );

        await FirebaseFirestore.instance.collection('groupChat').doc(docId).collection('messages').add(groupChatModel.toMap());
        await FirebaseFirestore.instance.collection('groupChat').doc(docId).update({
          'lastMsg': 'You Received a File',
        });
        if (!context.mounted) return;

        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        FocusScope.of(context).unfocus();
      } on FirebaseException catch (err) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showCustomMsg(err.message!);
      }
    }
  }

  sendingAudioFileInGroup({
    required BuildContext context,
    required String docId,
    required String audioFile,
  }) async {
    try {
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      GroupChatModel groupChatModel = GroupChatModel(
        msg: '',
        image: '',
        audioFile: audioFile,
        createdAt: DateTime.now(),
        file: '',
        senderId: snap['userId'],
        senderImage: snap['image'],
        senderName: snap['username'],
      );

      await FirebaseFirestore.instance.collection('groupChat').doc(docId).collection('messages').add(groupChatModel.toMap());
      await FirebaseFirestore.instance.collection('groupChat').doc(docId).update({
        'lastMsg': 'You Received an Audio',
      });
    } on FirebaseException catch (err) {
      showCustomMsg(err.message!);
    }
  }

  static deleteGroup(BuildContext context, String groupId) async {
    try {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);
      await FirebaseFirestore.instance.collection('groupChat').doc(groupId).delete();
      if (!context.mounted) return;
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Get.offAll(() => const CustomNavBar());
      showCustomMsg("Group Deleted");
    } on FirebaseException catch (e) {
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      showCustomMsg(e.message!);
    }
  }

  static deleteMsgInGroup(String chatId, String msgId, String content) async {
    await FirebaseFirestore.instance.collection('groupChat').doc(chatId).collection('messages').doc(msgId).delete();
    await FirebaseFirestore.instance.collection('groupChat').doc(chatId).update({
      'lastMsg': content,
    });
  }
}
