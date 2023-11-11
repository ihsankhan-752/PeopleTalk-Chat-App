import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:people_talk/models/user_model.dart';

class GetUserData extends ChangeNotifier {
  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  getUserData(String userId) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snap.exists) {
      _userModel = UserModel.fromDoc(snap);
      notifyListeners();
    }
  }
}
