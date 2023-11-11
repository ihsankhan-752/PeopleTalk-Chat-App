// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/models/status_model.dart';
import 'package:people_talk/services/storage_services.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class StatusController extends ChangeNotifier {
  List<StatusModel> _statusList = [];
  List<StatusModel> get statusList => _statusList;

  uploadStatus({
    required BuildContext context,
    required File image,
    required String title,
  }) async {
    if (image == null) {
      showCustomMsg("Upload Image");
    } else if (title.isEmpty) {
      showCustomMsg("Upload Title");
    } else {
      try {
        var docId = const Uuid().v4();
        Provider.of<LoadingController>(context, listen: false).setLoading(true);
        String imageUrl = await StorageServices().uploadImageToDb(image);

        StatusModel statusModel = StatusModel(
          docId: docId,
          image: imageUrl,
          createdAt: DateTime.now(),
          userId: FirebaseAuth.instance.currentUser!.uid,
          title: title,
          seenBy: [],
        );
        await FirebaseFirestore.instance.collection('status').doc(docId).set(statusModel.toMap());
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        Get.back();
      } on FirebaseException catch (e) {
        showCustomMsg(e.message!);
        Provider.of<LoadingController>(context, listen: false).setLoading(true);
      }
    }
  }

  getAllUsersStatus() async {
    try {
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      QuerySnapshot statusSnap =
          await FirebaseFirestore.instance.collection('status').where('userId', whereIn: snap['friendsList']).get();
      if (statusSnap.docs.isNotEmpty) {
        _statusList.clear();
        for (var i in statusSnap.docs) {
          StatusModel statusModel = StatusModel.fromDoc(i);
          _statusList.add(statusModel);
          notifyListeners();
        }
      }
    } on FirebaseException catch (e) {
      showCustomMsg(e.message!);
    }
  }
}
