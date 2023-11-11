import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  String? docId;
  String? userId;
  String? image;
  String? title;
  DateTime? createdAt;
  List? seenBy;

  StatusModel({
    required this.docId,
    required this.image,
    required this.createdAt,
    required this.userId,
    required this.title,
    required this.seenBy,
  });

  factory StatusModel.fromDoc(DocumentSnapshot snap) {
    return StatusModel(
      docId: snap['docId'],
      image: snap['image'],
      createdAt: (snap['createdAt'].toDate()),
      userId: snap['userId'],
      title: snap['title'],
      seenBy: snap['seenBy'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'userId': userId,
      'image': image,
      'title': title,
      'createdAt': createdAt,
      'seenBy': seenBy,
    };
  }
}
