import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_market_hewan/style/custom_container.dart';
import 'package:tubes_market_hewan/style/text.dart';

class UserProfil extends StatelessWidget {
  final String username;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  TextEditingController usernameController = TextEditingController();
  UserProfil({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    usernameController.text = username;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                height: 50,
                decoration: boxWhiteBorderRounded,
                child: TextField(
                  controller: usernameController,
                  style: text14_6navy,
                  decoration: const InputDecoration(
                    hintText: 'username',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  final db = FirebaseFirestore.instance;
                  db.collection("userData").doc(uid).set({
                    "username": usernameController.text,
                  }, SetOptions(merge: true));
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: boxNavyRounded,
                  child: Center(
                      child: Text(
                    "Update",
                    style: text14_6white,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
