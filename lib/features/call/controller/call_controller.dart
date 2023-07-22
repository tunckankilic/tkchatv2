import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tkchatv2/features/auth/auth.dart';
import 'package:tkchatv2/features/call/repository/call_repository.dart';
import 'package:tkchatv2/features/chat/repository/chat_repository.dart';
import 'package:tkchatv2/models/models.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    auth: FirebaseAuth.instance,
    callRepository: callRepository,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.auth,
    required this.callRepository,
    required this.ref,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(BuildContext context, String recieverName, String recieverUid,
      String profilePic, bool isGroupChat) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerNmae: value!.name,
        callerPic: value.profilePic,
        receiverId: recieverUid,
        receiverName: recieverName,
        receiverPic: profilePic,
        callId: callId,
        hasDialed: true,
      );
      Call receiverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerNmae: value.name,
        callerPic: value.profilePic,
        receiverId: recieverUid,
        receiverName: recieverName,
        receiverPic: profilePic,
        callId: callId,
        hasDialed: false,
      );
      callRepository.makeCall(senderCallData, context, receiverCallData);
    });
  }  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    callRepository.endCall(callerId, receiverId, context);
  }
}
