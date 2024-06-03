import 'package:e_commerce_ml/bottom_nav_bar_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                authService.signOut(context);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 2.5,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100)),
          color: Color(0xFF124076),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: currentUser!.photoURL != null
                  ? NetworkImage(
                      currentUser!.photoURL!,
                    )
                  : null,
              radius: 70,
              child: currentUser.photoURL == null
                  ? Icon(
                      Icons.person,
                      size: 120,
                      color: Colors.grey[600],
                    )
                  : null),
          Text(
            currentUser.displayName ?? "Kullanıcı",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          )
        ]),
      ),
    );
  }
}
