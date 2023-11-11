import 'package:cloud_firestore/cloud_firestore.dart';

class GroupCreatingModel {
  String? groupId;
  DateTime? groupCreatedAt;
  String? groupCreatorId;
  String? groupAdmin;
  String? groupName;
  String? groupBio;
  String? groupImage;
  List? ids;
  String? lastMsg;

  GroupCreatingModel({
    this.groupId,
    this.groupAdmin,
    this.groupBio,
    this.groupCreatedAt,
    this.groupCreatorId,
    this.groupImage,
    this.groupName,
    this.ids,
    this.lastMsg,
  });

  factory GroupCreatingModel.fromDoc(DocumentSnapshot snap) {
    return GroupCreatingModel(
      groupId: snap['groupId'],
      groupCreatedAt: (snap['groupCreatedAt'].toDate()),
      groupAdmin: snap['groupAdmin'],
      groupBio: snap['groupBio'],
      groupCreatorId: snap['groupCreatorId'],
      groupImage: snap['groupImage'],
      ids: snap['uids'],
      groupName: snap['groupName'],
      lastMsg: snap['lastMsg'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupCreatedAt': groupCreatedAt,
      'groupAdmin': groupAdmin,
      "groupBio": groupBio,
      'groupCreatorId': groupCreatorId,
      'groupImage': groupImage,
      'uids': ids,
      'groupName': groupName,
      'lastMsg': lastMsg,
    };
  }
}
