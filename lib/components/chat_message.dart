import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  void notification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    print(token);
  }

  @override
  void initState() {
    notification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapShot) {
        if (chatSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!chatSnapShot.hasData || chatSnapShot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No message found'),
          );
        }
        if (chatSnapShot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        //getting the data storing it init
        final loadedMessage = chatSnapShot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessage.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessage[index].data();
            final nextmessage = index + 1 < loadedMessage.length
                ? loadedMessage[index + 1].data()
                : null;
            final currentMessageUsernameId = chatMessage['userId'];
            final nextusernameId =
                nextmessage != null ? nextmessage['userId'] : null;
            ////////////////////////////////////////////////
            final nextUserSame = nextusernameId == currentMessageUsernameId;
            //////////////////////////////
            if (nextUserSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authUser.uid == currentMessageUsernameId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authUser.uid == currentMessageUsernameId,
              );
            }
          },
        );
      },
    );
  }
}
