import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final messageController = TextEditingController();

  void onMessageSubmit() async {
    final enteredText = messageController.text;
    if (enteredText.trim().isEmpty) {
      return;
    }
    messageController.clear();
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredText,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'imageUrl': userData.data()!['imageUrl']
    });


  }

  @override
  void dispose() {
    messageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              controller: messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              decoration: const InputDecoration(
                label: Text('Send a message...'),
              ),
            ),
          ),
          IconButton(
            onPressed: onMessageSubmit,
            icon:
                Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
