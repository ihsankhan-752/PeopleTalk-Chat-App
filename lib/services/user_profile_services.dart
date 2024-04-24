import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:people_talk/services/storage_services.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:provider/provider.dart';

import '../controllers/loading_controller.dart';

class UserProfileServices {
  Future<void> updateProfile({BuildContext? context, String? username, String? bio, int? contact}) async {
    try {
      Provider.of<LoadingController>(context!, listen: false).setLoading(true);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'username': username,
        'contact': contact,
        'bio': bio,
      });

      if (!context.mounted) return;
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      showCustomMsg(e.message!);
      Provider.of<LoadingController>(context!, listen: false).setLoading(false);
    }
  }

  static updateProfilePic(BuildContext context, dynamic image) async {
    try {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);
      String? imageUrl = await StorageServices().uploadImageToDb(image!);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'image': imageUrl,
      });

      if (!context.mounted) return;

      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      showCustomMsg(e.message!);
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
    }
  }
}
