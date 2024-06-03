import 'dart:convert';

import 'package:e_commerce_ml/screens/my_listings_screen/detailed_listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/advert_model.dart';
import '../services/firestore_service.dart';

FirestoreService firestoreService = FirestoreService();

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  List<Advert> myAdverts = [];
  bool isLoading = false;
  @override
  void initState() {
    getMyAdverts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlanlarım", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF124076),
      ),
      body: isLoading != true
          ? GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: MediaQuery.of(context).size.height / 2.7,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: Colors.grey,
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailedListing(advert: myAdverts[index])))
                        .then((value) => value == true ? getMyAdverts() : null);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(children: [
                      Expanded(
                        flex: 80,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              myAdverts[index].image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Text(
                          myAdverts[index].advertTitle!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Text(
                          myAdverts[index].isFree == false
                              ? "${myAdverts[index].price!.toString()}₺"
                              : "Ücretsiz",
                          style: TextStyle(
                              color: myAdverts[index].isFree == false
                                  ? Colors.black
                                  : Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                  ),
                );
              },
              itemCount: myAdverts.length)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void getMyAdverts() async {
    print("girdi");
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    myAdverts = await firestoreService
        .getMyAdverts(FirebaseAuth.instance.currentUser!.uid);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    print("girdi2");
  }
}
