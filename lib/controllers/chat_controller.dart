// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/services/notification_services.dart';
import 'package:people_talk/services/storage_services.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';

class ChatController extends ChangeNotifier {
  sendTextInChat({
    required BuildContext context,
    String? userId,
    String? msg,
    String? docId,
  }) async {
    if (msg!.isEmpty) {
      showErrorMsg(context, "Type Something");
    } else {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);
      try {
        DocumentSnapshot chatSnap = await FirebaseFirestore.instance.collection('chat').doc(docId).get();
        DocumentSnapshot userSnap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

        if (chatSnap.exists) {
          await FirebaseFirestore.instance.collection('chat').doc(docId).update({
            'msg': msg,
            'createdAt': DateTime.now(),
          });
        } else {
          await FirebaseFirestore.instance.collection('chat').doc(docId).set({
            'uids': [FirebaseAuth.instance.currentUser!.uid, userId],
            'msg': msg,
            'createdAt': DateTime.now(),
          });
        }
        ChatModel chatModel = ChatModel(
          msg: msg,
          image: '',
          file: '',
          audioFile: '',
          senderId: FirebaseAuth.instance.currentUser!.uid,
          senderImage: userSnap['image'],
          senderName: userSnap['username'],
          createdAt: DateTime.now(),
          isChecked: {
            FirebaseAuth.instance.currentUser!.uid: true,
            userId!: false,
          },
        );
        await FirebaseFirestore.instance.collection('chat').doc(docId).collection('messages').add(chatModel.toMap());

        await NotificationServices().sendNotificationToSpecificUser(
          title: "${userSnap['username']} Send a Text Message",
          body: msg,
          userId: userId,
        );
        Provider.of<LoadingController>(context, listen: false).setLoading(false);

        FocusScope.of(context).unfocus();
        notifyListeners();
      } on FirebaseException catch (e) {
        showErrorMsg(context, e.message.toString());
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
      }
    }
  }

  sendImageInChat({
    required BuildContext context,
    String? userId,
    File? image,
    String? docId,
  }) async {
    if (image == null) {
      showErrorMsg(context, "Image Is Empty");
    } else {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);
      try {
        DocumentSnapshot chatSnap = await FirebaseFirestore.instance.collection('chat').doc(docId).get();
        DocumentSnapshot userSnap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
        String imageUrl = await StorageServices().uploadImageToDb(image);

        if (chatSnap.exists) {
          await FirebaseFirestore.instance.collection('chat').doc(docId).update({
            'msg': 'You have Received an Image',
            'createdAt': DateTime.now(),
          });
        } else {
          await FirebaseFirestore.instance.collection('chat').doc(docId).set({
            'uids': [FirebaseAuth.instance.currentUser!.uid, userId],
            'msg': 'You have Received an Image',
            'createdAt': DateTime.now(),
          });
        }
        ChatModel chatModel = ChatModel(
          msg: '',
          file: '',
          audioFile: '',
          image: imageUrl,
          senderId: FirebaseAuth.instance.currentUser!.uid,
          senderImage: userSnap['image'],
          senderName: userSnap['username'],
          createdAt: DateTime.now(),
          isChecked: {
            FirebaseAuth.instance.currentUser!.uid: true,
            userId!: false,
          },
        );
        await FirebaseFirestore.instance.collection('chat').doc(docId).collection('messages').add(chatModel.toMap());
        await NotificationServices().sendNotificationToSpecificUser(
          title: "${userSnap['username']} Send an Image",
          body: '',
          userId: userId,
        );
        Provider.of<LoadingController>(context, listen: false).setLoading(false);

        FocusScope.of(context).unfocus();
        notifyListeners();
      } on FirebaseException catch (e) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);

        showErrorMsg(context, e.message.toString());
      }
    }
  }

  sendingFilesInChat({
    required BuildContext context,
    String? userId,
    File? file,
    String? docId,
  }) async {
    if (file == null) {
      showErrorMsg(context, "File Is Empty");
    } else {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);
      try {
        DocumentSnapshot chatSnap = await FirebaseFirestore.instance.collection('chat').doc(docId).get();
        DocumentSnapshot userSnap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
        String fileLink = await StorageServices().uploadImageToDb(file);

        if (chatSnap.exists) {
          await FirebaseFirestore.instance.collection('chat').doc(docId).update({
            'msg': 'You have Received a File',
            'createdAt': DateTime.now(),
          });
        } else {
          await FirebaseFirestore.instance.collection('chat').doc(docId).set({
            'uids': [FirebaseAuth.instance.currentUser!.uid, userId],
            'msg': 'You have Received a File',
            'createdAt': DateTime.now(),
          });
        }
        ChatModel chatModel = ChatModel(
          msg: '',
          image: '',
          file: fileLink,
          audioFile: '',
          senderId: FirebaseAuth.instance.currentUser!.uid,
          senderImage: userSnap['image'],
          senderName: userSnap['username'],
          createdAt: DateTime.now(),
          isChecked: {
            FirebaseAuth.instance.currentUser!.uid: true,
            userId!: false,
          },
        );
        await FirebaseFirestore.instance.collection('chat').doc(docId).collection('messages').add(chatModel.toMap());
        await NotificationServices().sendNotificationToSpecificUser(
          title: "${userSnap['username']} Send a File",
          body: '',
          userId: userId,
        );
        Provider.of<LoadingController>(context, listen: false).setLoading(false);

        FocusScope.of(context).unfocus();
        notifyListeners();
      } on FirebaseException catch (e) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);

        showErrorMsg(context, e.message.toString());
      }
    }
  }

  sendingAudioFileInChat({
    required BuildContext context,
    String? userId,
    String? docId,
    String? audioUrl,
  }) async {
    try {
      DocumentSnapshot chatSnap = await FirebaseFirestore.instance.collection('chat').doc(docId).get();
      DocumentSnapshot userSnap =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      if (chatSnap.exists) {
        await FirebaseFirestore.instance.collection('chat').doc(docId).update({
          'msg': 'You have Received a Voice',
          'createdAt': DateTime.now(),
        });
      } else {
        await FirebaseFirestore.instance.collection('chat').doc(docId).set({
          'uids': [FirebaseAuth.instance.currentUser!.uid, userId],
          'msg': 'You have Received a Voice',
          'createdAt': DateTime.now(),
        });
      }
      ChatModel chatModel = ChatModel(
        msg: '',
        image: '',
        file: '',
        audioFile: audioUrl,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        senderImage: userSnap['image'],
        senderName: userSnap['username'],
        createdAt: DateTime.now(),
        isChecked: {
          FirebaseAuth.instance.currentUser!.uid: true,
          userId!: false,
        },
      );
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(docId)
          .collection('messages')
          .add(chatModel.toMap())
          .then((value) {
        audioUrl = '';
      });
      await NotificationServices().sendNotificationToSpecificUser(
        title: "${userSnap['username']} Send an Audio",
        body: '',
        userId: userId,
      );

      notifyListeners();
    } on FirebaseException catch (e) {
      showErrorMsg(context, e.message.toString());
    }
  }
}
