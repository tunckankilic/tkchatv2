import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tkchatv2/models/models.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    //users --> sender id --> reciever id --> messages --> messages id --> store message
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection("users").doc(receiverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
      //users --> reciever user id --> set data
      _saveDataToContactsSubcollection();
    } catch (e) {}
  }
  
  void _saveDataToContactsSubcollection() {}
}
