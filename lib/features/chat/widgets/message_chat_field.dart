import 'dart:io';

import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:tkchatv2/common/enums/message_enum.dart';
import 'package:tkchatv2/common/utils/colors.dart';
import 'package:tkchatv2/common/utils/utils.dart';
import 'package:tkchatv2/features/chat/controller/chat_controller.dart';

class MessageChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const MessageChatField({
    super.key,
    required this.recieverUserId,
  });

  @override
  ConsumerState<MessageChatField> createState() => _MessageChatFieldState();
}

class _MessageChatFieldState extends ConsumerState<MessageChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text,
            recieverUserId: widget.recieverUserId,
          );
    }
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          messageEnum: messageEnum,
          recieverUserId: widget.recieverUserId,
        );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              } else {
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.gif,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
          child: GestureDetector(
            onTap: () {
              if (_messageController.text.isEmpty) return;
              sendTextMessage();
              _messageController.clear();
            },
            child: CircleAvatar(
              backgroundColor: const Color.fromRGBO(5, 96, 98, 1),
              radius: 25,
              child: Icon(isShowSendButton ? Icons.send : Icons.mic),
            ),
          ),
        )
      ],
    );
  }
}
