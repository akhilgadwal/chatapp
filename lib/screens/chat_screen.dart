import 'package:chatapp/components/chat_message.dart';
import 'package:chatapp/components/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final _firebase = FirebaseAuth.instance;

  Future<void> signout() async {
    _firebase.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Screen'),
          actions: [
            IconButton(
                onPressed: signout,
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
        ),
        body: Column(
          children: const [Expanded(child: ChatMessage()), NewMessage()],
        ));
  }
}
