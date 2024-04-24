import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:people_talk/models/user_model.dart';

class GetUserData extends ChangeNotifier {
  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;
  getUserData() async {
    try {
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots().listen((snap) {
        if (snap.exists) {
          _userModel = UserModel.fromDoc(snap);
        } else {
          throw 'No User Found';
        }
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
