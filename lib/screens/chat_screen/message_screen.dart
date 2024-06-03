import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/advert_model.dart';

class ChatMessage {
  final String message;
  final String senderId;
  final String receiverId;
  final DateTime sentTime;
  final String receiverName;
  final String senderName;

  ChatMessage(
      {required this.message,
      required this.receiverId,
      required this.senderId,
      required this.sentTime,
      required this.receiverName,
      required this.senderName});
}

class MessageScreen extends StatefulWidget {
  const MessageScreen(
      {Key? key,
      required this.advertId,
      required this.receiverName,
      this.receiverId = "",
      required this.senderId,
      required this.senderName,
      this.advertIcon = ""})
      : super(key: key);

  final String receiverName;
  final String senderId;
  final String senderName;
  final String advertId;
  final String receiverId;
  final String? advertIcon;
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  ScrollController scrollController = ScrollController();
  String senderName = "";
  List<ChatMessage> chatMessages = [];
  TextEditingController _controller =
      TextEditingController(); // Controller added

  @override
  void initState() {
    getMessages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            userId == widget.receiverId
                ? widget.senderName
                : widget.receiverName,
            style: const TextStyle(color: Colors.white),
          ),
          foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: getMessages(),
                builder: (context, snapshot) {
                  scrolldown();
                  if (snapshot.data != null) {
                    print(snapshot.data!.size);
                    chatMessages = snapshot.data!.docs
                        .map((e) => ChatMessage(
                            message: e.data()['message'],
                            receiverId: e.data()['receiverId'],
                            senderId: e.data()['senderId'],
                            sentTime: DateTime.fromMicrosecondsSinceEpoch(
                                e.data()['sentTime'].microsecondsSinceEpoch),
                            receiverName: e.data()['receiverName'],
                            senderName: e.data()['senderName']))
                        .toList();

                    for (var element in chatMessages) {
                      print(element.message);
                    }
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: chatMessages[index].senderId == userId
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: chatMessages[index].senderId == userId
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              chatMessages[index].message,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        _controller, // Attach the controller to the TextField
                    decoration: const InputDecoration(
                      hintText: 'Mesajınızı buraya yazın...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text;
                    if (message.isNotEmpty) {
                      if (chatMessages.isEmpty) {
                        firstMessage();
                      }
                      _sendMessage(message);

                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void firstMessage() async {
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.receiverId)
        .collection('chatilanlar')
        .doc(widget.advertId)
        .collection("chats")
        .doc(senderId)
        .set({
      "name": widget.senderName,
      "uid": widget.senderId,
      "icon": widget.advertIcon,
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(senderId)
        .collection('chatilanlar')
        .doc(widget.advertId)
        .collection("chats")
        .doc(widget.receiverId)
        .set({
      "name": widget.receiverName,
      "uid": widget.receiverId,
      "icon": widget.advertIcon,
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.receiverId)
        .collection('chatilanlar')
        .doc(widget.advertId)
        .set({"name": "1"});

    await FirebaseFirestore.instance
        .collection("users")
        .doc(senderId)
        .collection('chatilanlar')
        .doc(widget.advertId)
        .set({"name": "1"});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages() {
    String receiverId = widget.receiverId;
    String senderId = widget.senderId;
    String counterUserId = FirebaseAuth.instance.currentUser!.uid == receiverId
        ? senderId
        : receiverId;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chatilanlar")
        .doc(widget.advertId)
        .collection("chats")
        .doc(counterUserId)
        .collection("messages")
        .orderBy("sentTime", descending: false)
        .snapshots(includeMetadataChanges: true);
  }

  void _sendMessage(String message) async {
    String receiverId = widget.receiverId;
    String senderId = FirebaseAuth.instance.currentUser!.uid;

    //print to database which is the senders
    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection('chatilanlar')
        .doc(widget.advertId)
        .collection("chats")
        .doc(senderId)
        .collection("messages")
        .doc()
        .set({
      "message": message,
      "receiverId": receiverId,
      "sentTime": DateTime.now(),
      "receiverName": widget.receiverName,
      "advertId": widget.advertId,
      "senderId": FirebaseAuth.instance.currentUser!.uid,
      "senderName": widget.senderName
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(senderId)
        .collection('chatilanlar')
        .doc(widget.advertId)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc()
        .set({
      "message": message,
      "receiverId": receiverId,
      "sentTime": DateTime.now(),
      "receiverName": widget.receiverName,
      "advertId": widget.advertId,
      "senderId": FirebaseAuth.instance.currentUser!.uid,
      "senderName": widget.senderName
    });
    scrolldown();
  }

  void scrolldown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}
