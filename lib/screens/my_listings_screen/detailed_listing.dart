import 'dart:convert';

import 'package:e_commerce_ml/screens/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/advert_model.dart';

FirestoreService _firestoreService = FirestoreService();

class DetailedListing extends StatelessWidget {
  const DetailedListing({super.key, required this.advert});
  final Advert advert;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(children: [
            Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 1.8,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      child: Image.network(
                        advert.image!,
                        fit: BoxFit.fill,
                      ),
                    )),
                Positioned(
                  top: 30,
                  left: 20,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 20,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                        onPressed: () {
                          _firestoreService.deleteAnAdvert(advert.advertId!);
                          Navigator.pop(context, true);
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Text(
                            advert.advertTitle!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          const Spacer(),
                          Text(
                            advert.isFree == false
                                ? advert.price.toString()
                                : "Ücretsiz",
                            style: TextStyle(
                                color: advert.isFree == true
                                    ? Colors.green
                                    : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Açıklama",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        advert.description!,
                        style: TextStyle(fontSize: 17, color: Colors.grey[500]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Ürün durumu",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(advert.status!,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[500],
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Satıcı",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(advert.advertiserName!,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[500],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
