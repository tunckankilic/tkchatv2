// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tkchatv2/common/utils/colors.dart';
import 'package:tkchatv2/common/widgets/loader.dart';
import 'package:tkchatv2/features/auth/auth.dart';
import 'package:tkchatv2/features/chat/controller/chat_controller.dart';
import 'package:tkchatv2/features/chat/widgets/chat_list.dart';
import 'package:tkchatv2/models/models.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = "/mobile-chat-screen";
  final String name;
  final String uid;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    snapshot.data!.isOnline ? "online" : "offline",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          MessageChatField(
            recieverUserId: uid,
          ),
        ],
      ),
    );
  }
}

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
                      onPressed: () {},
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
