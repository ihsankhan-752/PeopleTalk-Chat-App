import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? notificationId;
  String? fromUserId;
  String? toUserId;
  String? notificationTitle;
  String? notificationBody;
  DateTime? createdAt;

  NotificationModel({
    this.notificationId,
    this.fromUserId,
    this.toUserId,
    this.notificationTitle,
    this.notificationBody,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'notificationTitle': notificationTitle,
      'notificationBody': notificationBody,
      'createdAt': createdAt,
    };
  }

  factory NotificationModel.fromMap(DocumentSnapshot map) {
    return NotificationModel(
      notificationId: map['notificationId'] as String,
      fromUserId: map['fromUserId'] as String,
      toUserId: map['toUserId'] as String,
      notificationTitle: map['notificationTitle'] as String,
      notificationBody: map['notificationBody'] as String,
      createdAt: (map['createdAt'].toDate()),
    );
  }
}
