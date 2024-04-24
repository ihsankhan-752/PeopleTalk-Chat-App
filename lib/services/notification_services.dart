import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:people_talk/models/notification_model.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:uuid/uuid.dart';

import '../constants/keys.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void getPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      carPlay: true,
      provisional: true,
      criticalAlert: true,
      badge: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("Authorized");
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        if (kDebugMode) {
          print("Provisional State Granted");
        }
      } else {
        return null;
      }
    }
  }

  void getDeviceToken() async {
    String? token = await messaging.getToken();
    await FirebaseFirestore.instance.collection('tokens').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'token': token,
    });
  }

  void initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting, onDidReceiveNotificationResponse: (payload) {
      // handleMessage(context, message, message.data['userId']);
    });
  }

  void initNotification(BuildContext context) async {
    //TerminatedState
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      if (kDebugMode) {
        print("It is Terminated State");
      }
    }

    //Foreground State
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        if (Platform.isAndroid) {
          initLocalNotifications(context, remoteMessage);
          showNotification(context, remoteMessage);
          //handleNotification
        } else {
          showNotification(context, remoteMessage);
          //handleNotification
        }
      }
    });

    //backGround State
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        if (kDebugMode) {
          print("BackGround State");
        }
      }
    });
  }

  Future<void> showNotification(BuildContext context, RemoteMessage message) async {
    initLocalNotifications(context, message);
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "High Importance Notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "your channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message, String? userId) {
    if (kDebugMode) {
      print("Handle Notification Called =============== ${message.data}");
    }
    if (message.data['userId'] == userId) {
      if (kDebugMode) {
        print("userData:$userId");
      }
    } else {
      if (kDebugMode) {
        print("No userId Found");
      }
    }
  }

  sendNotificationToSpecificUser({required String title, required String body, required String userId}) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('tokens').doc(userId).get();

    Map<String, String> notificationHeader = {
      'Content-Type': "application/json",
      'Authorization': messagingKey,
    };
    Map notificationBody = {
      'title': title,
      'body': body,
    };
    Map notificationData = {
      'status': "done",
      'userId': userId,
      'click_action': "FLUTTER_NOTIFICATION_CLICK",
    };
    Map notificationFormat = {
      'notification': notificationBody,
      'data': notificationData,
      'to': snap['token'],
      'priority': 'high',
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: notificationHeader,
      body: jsonEncode(notificationFormat),
    );
  }

  static addNotificationInDb({
    required String notificationTitle,
    required String notificationBody,
    required String toUserId,
  }) async {
    try {
      var notificationId = const Uuid().v4();

      NotificationModel notificationModel = NotificationModel(
        notificationId: notificationId,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
        fromUserId: FirebaseAuth.instance.currentUser!.uid,
        toUserId: toUserId,
        createdAt: DateTime.now(),
      );
      await FirebaseFirestore.instance.collection('notifications').doc(notificationId).set(notificationModel.toMap());
    } on FirebaseException catch (e) {
      showCustomMsg(e.message!);
    }
  }
}
