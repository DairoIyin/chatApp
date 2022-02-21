import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mi_flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
ScrollController _controller = ScrollController();
User? loggedInUser;
bool isMe = false;

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //messageController is used to control our text field. Here we use .clear() to clear it when the send button is pressed.
  final messageController = TextEditingController();
  String messageText = '';
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      try {
        loggedInUser = user;
      } catch (e) {
        print(e);
      }
    }
  }
//BOTH METHODS HAVE BEEN REPLACED WITH MESSAGESTREAM()
  //This method is inefficient because we will need to call it to maually refresh and get new messages

  // void getMessages() async {
  //   //get returns a future of type Query Snapshot. Its basically a snapshot of the data in our collection.
  //   final messages = await _firestore.collection('messages').get();
  //   //.docs returns a list of all our documents in the collection
  //   for (var message in messages.docs) {
  //     //.data returns the key-value pairs that are in our documents that are in our collection... heh
  //     print(message.data());
  //   }
  // }

  //this need only be called once and will subsequently notify automatically whenever the database is updated with new messages from the user.
  // void messagesStreams() async {
  //   await for (var snapshots in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshots.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //QuerySnaphot type must be specified otherwise snapshot.data wont be recognised
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                        'timestamp': FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            _firestore.collection('messages').orderBy("timestamp").snapshots(),

        //this snapshot is of type AsyncSnapshot, It actually contains the QuerySnapshots from Firebase
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            ));
          }
          //these snapshots contain a LIST of document snapshots
          final messages = snapshot.data?.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages!.reversed) {
            //getting the values from the key-values pairs of data
            final messageText = message['text'];
            final messageSender = message['sender'];
            final currentUser = loggedInUser?.email;
            final messageWidget = MessageBubble(
                text: messageText,
                sender: messageSender,
                isMe: currentUser == messageSender);

            messageBubbles.add(messageWidget);
          }

          return Expanded(
            child: ListView(
              controller: _controller,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              reverse: true,
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  //isMe checks whether the sender of the message is the current Logged in user.
  MessageBubble({required this.text, required this.sender, required this.isMe});
  final bool isMe;
  final String sender;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
