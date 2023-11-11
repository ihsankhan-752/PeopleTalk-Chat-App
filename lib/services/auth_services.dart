import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:people_talk/models/user_model.dart';
import 'package:people_talk/screens/auth/login_screen.dart';
import 'package:people_talk/screens/auth/user_info_entering_screen.dart';
import 'package:people_talk/screens/home/home_screen.dart';
import 'package:people_talk/services/storage_services.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';

class AuthServices extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setLoading(newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  userSignUp({
    String? username,
    String? email,
    String? password,
    int? contact,
  }) async {
    if (username!.isEmpty) {
      showCustomMsg('Enter your name please!');
    } else if (email!.isEmpty) {
      showCustomMsg('Email Must Be Filled');
    } else if (contact == null) {
      showCustomMsg('Contact Number must Be Entered');
    } else if (password!.isEmpty) {
      showCustomMsg('Password Required');
    } else {
      setLoading(true);

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        UserModel userModel = UserModel(
          userId: FirebaseAuth.instance.currentUser!.uid,
          username: username,
          email: email,
          contact: contact,
          bio: "",
          image: "",
          friendsList: [],
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(userModel.toMap());
        setLoading(false);
        Get.to(() => const UserInformationEnteringScreen());
      } on FirebaseException catch (err) {
        setLoading(false);
        showCustomMsg(err.message.toString());
      }
    }
  }

  updateBioAndImageForProfile(File image, String bio) async {
    if (image == null) {
      showCustomMsg("Image Is Required");
    } else if (bio.isEmpty) {
      showCustomMsg("Enter Something About yourself");
    } else {
      setLoading(true);
      try {
        String imageUrl = await StorageServices().uploadImageToDb(File(image.path));

        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'image': imageUrl,
          "bio": bio,
        });
        setLoading(false);
        Get.to(() => const HomeScreen());
      } catch (e) {
        setLoading(false);
        showCustomMsg(e.toString());
      }
    }
  }

  signIn(String email, String password) async {
    if (email.isEmpty) {
      showCustomMsg("Email is Required");
    } else if (password.isEmpty) {
      showCustomMsg("Password is Required");
    } else {
      setLoading(true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        setLoading(false);

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Get.to(() => const HomeScreen());
      } on FirebaseAuthException catch (e) {
        setLoading(false);
        showCustomMsg(e.message.toString());
      }
    }
  }

  resetPassword(String email) async {
    if (email.isEmpty) {
      showCustomMsg("Email Must Be Filled");
    } else {
      setLoading(true);
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        setLoading(false);
        showCustomMsg("Email Is Successfully Sent to Your $email \n Try to Logged In with your new Password");
        Get.to(() => const LoginScreen());
      } on FirebaseAuthException catch (e) {
        setLoading(false);
        showCustomMsg(e.message.toString());
      }
    }
  }

  logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.to(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      showCustomMsg(e.message!);
    }
  }

  addUserToFriendList(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'friendsList': FieldValue.arrayUnion([userId]),
      });
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'friendsList': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
    } on FirebaseException catch (e) {
      showCustomMsg(e.message!);
    }
  }
}
