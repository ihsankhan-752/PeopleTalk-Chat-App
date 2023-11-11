import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatModel {
  String msg;
  String audioFile;
  String image;
  String file;
  String senderId;
  String senderName;
  String senderImage;
  DateTime createdAt;

  GroupChatModel({
    required this.msg,
    required this.file,
    required this.image,
    required this.audioFile,
    required this.createdAt,
    required this.senderId,
    required this.senderImage,
    required this.senderName,
  });

  factory GroupChatModel.fromDoc(DocumentSnapshot snap) {
    return GroupChatModel(
      msg: snap['msg'],
      image: snap['image'],
      file: snap['file'],
      audioFile: snap['audioFile'],
      createdAt: (snap['createdAt'].toDate()),
      senderId: snap['senderId'],
      senderImage: snap['senderImage'],
      senderName: snap['senderName'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'msg': msg,
      'image': image,
      'audioFile': audioFile,
      'createdAt': createdAt,
      'file': file,
      'senderId': senderId,
      'senderName': senderName,
      'senderImage': senderImage,
    };
  }
}
