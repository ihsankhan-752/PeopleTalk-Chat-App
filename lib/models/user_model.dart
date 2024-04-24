import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? username;
  String? email;
  String? bio;
  int? contact;
  String? image;
  List? friendsList;
  List? sendRequestList;
  List? receivedRequestList;
  DateTime? memberSince;

  UserModel({
    this.userId,
    this.username,
    this.email,
    this.image,
    this.bio,
    this.contact,
    this.friendsList,
    this.memberSince,
    this.sendRequestList,
    this.receivedRequestList,
  });
  factory UserModel.fromDoc(DocumentSnapshot snap) {
    return UserModel(
      userId: snap['userId'],
      username: snap['username'],
      email: snap['email'],
      contact: snap['contact'],
      bio: snap['bio'],
      image: snap['image'],
      friendsList: snap['friendsList'],
      sendRequestList: snap['sendRequestList'],
      receivedRequestList: snap['receivedRequestList'],
      memberSince: (snap['memberSince'].toDate()),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'contact': contact,
      'bio': bio,
      'image': image,
      'friendsList': friendsList,
      'sendRequestList': sendRequestList,
      'receivedRequestList': receivedRequestList,
      'memberSince': memberSince,
    };
  }
}
