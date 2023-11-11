import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? msg;
  String? image;
  String? file;
  String? senderId;
  String? senderImage;
  String? senderName;
  String? audioFile;
  DateTime? createdAt;
  Map<String, dynamic>? isChecked;

  ChatModel({
    this.msg,
    this.image,
    this.file,
    this.senderId,
    this.senderImage,
    this.senderName,
    this.audioFile,
    this.createdAt,
    this.isChecked,
  });

  factory ChatModel.fromDoc(DocumentSnapshot snap) {
    return ChatModel(
      msg: snap['msg'],
      image: snap['image'],
      senderId: snap['senderId'],
      senderImage: snap['senderImage'],
      senderName: snap['senderName'],
      isChecked: snap['isChecked'],
      audioFile: snap['audioFile'],
      file: snap['file'],
      createdAt: (snap['createdAt'].toDate()),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'msg': msg,
      'image': image,
      'senderName': senderName,
      'senderId': senderId,
      'senderImage': senderImage,
      'createdAt': createdAt,
      'audioFile': audioFile,
      'file': file,
      'isChecked': isChecked,
    };
  }
}
