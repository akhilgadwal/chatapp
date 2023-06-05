import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  //creating a controller for it
  final _messageContoller = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  //disposing it
  @override
  void dispose() {
    _messageContoller.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final entermessage = _messageContoller.text;
    if (entermessage.trim().isEmpty) {
      return;
    }
    //getting the data
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    //send data to firebase
    FirebaseFirestore.instance.collection('chats').add({
      'text': _messageContoller.text,
      'createdAt': Timestamp.now(),
      'userId': currentUser.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['imageurl'],
    });
    _messageContoller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 1,
        bottom: 14,
        left: 15,
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _messageContoller,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(
              hintText: 'Send Message',
            ),
          ),
        ),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ]),
    );
  }
}
