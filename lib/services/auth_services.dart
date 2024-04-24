import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/models/user_model.dart';
import 'package:people_talk/screens/auth/login_screen.dart';
import 'package:people_talk/screens/custom_navbar/custom_navbar.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:provider/provider.dart';

import '../controllers/loading_controller.dart';

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
          sendRequestList: [],
          receivedRequestList: [],
          memberSince: DateTime.now(),
        );
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(userModel.toMap());
        setLoading(false);
        Get.to(() => const CustomNavBar());
      } on FirebaseException catch (err) {
        setLoading(false);
        showCustomMsg(err.message.toString());
      }
    }
  }

  signIn(BuildContext context, String email, String password) async {
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

        await FirebaseAuth.instance.authStateChanges().first;

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          QuerySnapshot snap = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
          if (snap.docs.isNotEmpty) {
            setLoading(false);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomNavBar()));
          } else {
            setLoading(false);
            showCustomMsg("No User Found!");
          }
        } else {
          setLoading(false);
          showCustomMsg("Authentication Failed");
        }

        setLoading(false);
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
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      showCustomMsg(e.message!);
    }
  }

  deleteAccount(BuildContext context) async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).delete();

    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
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

  static Future<bool> checkOldPasswordCreative(email, password) async {
    AuthCredential authCredential = EmailAuthProvider.credential(email: email, password: password);
    try {
      var credentialResult = await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(authCredential);
      return credentialResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> changeUserPasswordCreative({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (oldPassword.isEmpty) {
      showCustomMsg("Old password required");
    } else if (newPassword.isEmpty) {
      showCustomMsg("New password required");
    } else if (newPassword != confirmPassword) {
      showCustomMsg("Password does not match");
    } else {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);
      bool checkPassword = true;
      checkPassword = await checkOldPasswordCreative(
        FirebaseAuth.instance.currentUser!.email,
        oldPassword,
      );
      if (checkPassword) {
        try {
          await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
          Provider.of<LoadingController>(context, listen: false).setLoading(false);

          showCustomMsg("Password Updated Successfully");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        } catch (e) {
          Provider.of<LoadingController>(context, listen: false).setLoading(false);
          showCustomMsg(e.toString());
        }
      } else {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showCustomMsg("Invalid Password");
      }
    }
  }
}
