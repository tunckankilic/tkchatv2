import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GroupC {
  final String senderId;
  final String name;
  final String groupId;
  final String groupPic;
  final String lastMessage;
  final List<String> membersUid;
  GroupC({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.groupPic,
    required this.lastMessage,
    required this.membersUid,
  });



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'groupPic': groupPic,
      'lastMessage': lastMessage,
      'membersUid': membersUid,
    };
  }

  factory GroupC.fromMap(Map<String, dynamic> map) {
    return GroupC(
      senderId: map['senderId'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      groupPic: map['groupPic'] as String,
      lastMessage: map['lastMessage'] as String,
      membersUid: List<String>.from((map['membersUid'] as List<String>)),
    );
  }

}
