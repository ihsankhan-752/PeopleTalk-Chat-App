import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/app_colors.dart';
import 'package:people_talk/constants/app_text_style.dart';
import 'package:people_talk/controllers/audio_recording_controller.dart';
import 'package:people_talk/controllers/file_controller.dart';
import 'package:people_talk/controllers/get_all_users.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:people_talk/controllers/image_controller.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/controllers/status_controller.dart';
import 'package:people_talk/controllers/visibility_controller.dart';
import 'package:people_talk/screens/splash/splash_screen.dart';
import 'package:people_talk/services/auth_services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
        ChangeNotifierProvider(create: (_) => ImageController()),
        ChangeNotifierProvider(create: (_) => VisibilityController()),
        ChangeNotifierProvider(create: (_) => LoadingController()),
        ChangeNotifierProvider(create: (_) => FileController()),
        ChangeNotifierProvider(create: (_) => AudioRecordingController()),
        ChangeNotifierProvider(create: (_) => GetUserData()),
        ChangeNotifierProvider(create: (_) => StatusController()),
        ChangeNotifierProvider(create: (_) => GetAllUsers()),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.lightPrimaryColor,
            centerTitle: true,
            titleTextStyle: AppTextStyle.main.copyWith(fontSize: 18, letterSpacing: 1.5),
            iconTheme: IconThemeData(
              color: AppColors.primaryWhite,
            ),
          ),
          scaffoldBackgroundColor: AppColors.lightPrimaryColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
