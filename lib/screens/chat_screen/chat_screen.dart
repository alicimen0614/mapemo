import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_ml/screens/chat_screen/message_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatUsersState();
}

class _ChatUsersState extends State<ChatScreen> {
  bool isLoading = false;
  List chats = [];
  List adverts = [];
  @override
  void initState() {
    getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "Sohbet",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true),
        body: isLoading == false
            ? ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                padding: const EdgeInsets.all(10),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Text(chats[index][0]['name']),
                    leading: const Icon(Icons.person, size: 40),
                    trailing: SizedBox(
                        height: 50,
                        child: Image.memory(
                            base64Decode(chats[index][0]['icon']))),
                    tileColor: Colors.grey.shade400,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageScreen(
                              advertId: chats[index][0]['advert'],
                              receiverName: chats[index][0]['name'],
                              receiverId: chats[index][0]['uid'],
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              senderName: FirebaseAuth
                                  .instance.currentUser!.displayName!,
                            ),
                          ));
                    },
                  );
                })
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  Future<void> getAdverts() async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chatilanlar")
        .get();
    print(data.docs);
    adverts = data.docs.map((e) => e.id).toList();
  }

  Future<void> getChats() async {
    setState(() {
      isLoading = true;
    });
    await getAdverts();
    for (var advert in adverts) {
      var data = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("chatilanlar")
          .doc(advert)
          .collection("chats")
          .get();

      chats.add(data.docs.map((e) => {...e.data(), "advert": advert}).toList());
    }
    setState(() {
      isLoading = false;
    });
  }
}
