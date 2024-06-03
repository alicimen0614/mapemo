import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_ml/models/advert_model.dart';
import 'package:e_commerce_ml/screens/my_listings_screen/my_listings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final storage = FirebaseStorage.instance;

  Future<void> createAnAdvert(var data) async {
    firebase.collection("adverts").doc().set(data);
  }

  Future<List<Advert>> getAdverts() async {
    print("çalıştı");
    var data = await firebase.collection("adverts").get();
    var data2 = data.docs;
    List<Advert> realData = data2
        .map((e) => Advert.fromJson({...e.data(), "advertId": e.reference.id}))
        .toList();
    return realData;
  }

  Future<void> deleteAnAdvert(String id) async {
    await firebase.collection("adverts").doc(id).delete();
  }

  Future<List<Advert>> getMyAdverts(String id) async {
    print("çalıştı");
    var data = await firebase
        .collection("adverts")
        .where("advertiserId", isEqualTo: id)
        .get();
    var data2 = data.docs;
    List<Advert> realData = data2
        .map((e) => Advert.fromJson({...e.data(), "advertId": e.reference.id}))
        .toList();
    return realData;
  }

  Future<String> uploadImage(File fileName) async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var taskSnapshot =
        await storage.ref().child('post_images/$imageName').putFile(fileName);
    var url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<List<Advert>> getAdvertsByFilter(String category) async {
    var data = await firebase
        .collection("adverts")
        .where("category", isEqualTo: category)
        .get();
    return data.docs.map((e) => Advert.fromJson(e.data())).toList();
  }
}
