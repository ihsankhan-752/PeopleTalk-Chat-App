import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';

import '../models/user_model.dart';

class GetAllUsers extends ChangeNotifier {
  List<UserModel> _userModel = [];

  List<UserModel> get userModel => _userModel;

  Future<void> getAllUsers() async {
    try {
      FirebaseFirestore.instance.collection('users').snapshots().listen((snap) {
        _userModel.clear();

        for (var user in snap.docs) {
          UserModel newUserModel = UserModel.fromDoc(user);
          _userModel.add(newUserModel);
        }
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      showCustomMsg(e.message!);
    }
  }
}
