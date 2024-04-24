import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:provider/provider.dart';

class FriendsServices {
  static addFriend(BuildContext context, String friendId) async {
    try {
      Provider.of<LoadingController>(context, listen: false).setLoadingForSpecificUser(true, userId: friendId);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'sendRequestList': FieldValue.arrayUnion([friendId]),
      });
      await FirebaseFirestore.instance.collection('users').doc(friendId).update({
        'receivedRequestList': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });

      if (!context.mounted) return;
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Provider.of<LoadingController>(context, listen: false).setLoadingForSpecificUser(false, userId: friendId);
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Provider.of<LoadingController>(context, listen: false).setLoadingForSpecificUser(false, userId: friendId);

      showCustomMsg(e.message!);
    }
  }

  static cancelSendRequest(BuildContext context, String friendId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'sendRequestList': FieldValue.arrayRemove([friendId]),
      });
      await FirebaseFirestore.instance.collection('users').doc(friendId).update({
        'receivedRequestList': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
      Get.back();
    } on FirebaseException catch (e) {
      showCustomMsg(e.message!);
    }
  }

  static rejectComingRequest(BuildContext context, String friendId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(friendId).update({
        'sendRequestList': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'receivedRequestList': FieldValue.arrayRemove([friendId]),
      });

      Get.back();
    } on FirebaseException catch (e) {
      showCustomMsg(e.message!);
    }
  }

  static acceptFriendRequest(BuildContext context, String friendId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(friendId).update({
        'sendRequestList': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'receivedRequestList': FieldValue.arrayRemove([friendId]),
      });
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'friendsList': FieldValue.arrayUnion([friendId]),
      });
      await FirebaseFirestore.instance.collection('users').doc(friendId).update({
        'friendsList': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
      Get.back();
    } on FirebaseException catch (e) {
      showCustomMsg(e.message!);
    }
  }
}
