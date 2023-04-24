import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tkchatv2/common/enums/message_enum.dart';
import 'package:tkchatv2/features/auth/auth.dart';
import 'package:tkchatv2/features/chat/repository/chat_repository.dart';
import 'package:tkchatv2/models/chat_contact.dart';
import 'package:tkchatv2/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({required this.chatRepository, required this.ref});
  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId}) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
          ),
        );
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required MessageEnum messageEnum,
    required String recieverUserId,
  }) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
          ),
        );
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  void sendGifMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
  }) {
    int gifUrlPartIndex = gifUrl.lastIndexOf("-") + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = "https://i.giphy.com/media/$gifUrlPart/200.gif";

    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendGifMessage(
              context: context,
              gifUrl: newGifUrl,
              recieverUserId: recieverUserId,
              senderUser: value!,
            ));
  }
}
