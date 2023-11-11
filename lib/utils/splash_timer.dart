import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:people_talk/screens/auth/login_screen.dart';
import 'package:people_talk/screens/home/home_screen.dart';

splashTimer() {
  Timer(const Duration(seconds: 3), () {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.to(() => const HomeScreen());
    } else {
      Get.to(() => const LoginScreen());
    }
  });
}
