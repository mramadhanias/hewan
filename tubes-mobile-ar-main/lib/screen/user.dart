import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_market_hewan/auth/login.dart';
import 'package:tubes_market_hewan/data/data.dart';
import 'package:tubes_market_hewan/screen/change_image.dart';
import 'package:tubes_market_hewan/screen/product_add.dart';
import 'package:tubes_market_hewan/screen/show_image.dart';
import 'package:tubes_market_hewan/screen/user_profil.dart';
import 'package:tubes_market_hewan/style/color.dart';
import 'package:tubes_market_hewan/style/text.dart';

class User extends StatelessWidget {
  User({super.key});
  final GlobalKey<ShowImageState> childKey = GlobalKey<ShowImageState>();
  final auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final email = FirebaseAuth.instance.currentUser?.email;
  final db = FirebaseFirestore.instance;
  var data;

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return StreamBuilder(
      stream: db.collection("userData").doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }
        data = snapshot.data!.data();
        // print(data);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    size: 20,
                    color: navy,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Akun saya",
                    style: text16_6navy,
                  ),
                  const Spacer(),
                  (data?['role'] == "admin")
                      ? InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProductAdd())),
                          child: const FaIcon(
                            FontAwesomeIcons.layerGroup,
                            size: 18,
                            color: yellow,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              UserProfil(username: data?['username']),
                        )),
                    child: const FaIcon(
                      FontAwesomeIcons.bars,
                      size: 20,
                      color: navy,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ShowImage(key: childKey, path: "profile_images/$uid"),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?['username'] ?? '',
                        style: text14_6navy,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(truncateText(email.toString(), 20))
                    ],
                  ),
                  const Spacer(),
                  ChangeImage(childKey: childKey),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 10,
              width: mediaQuery.size.width,
              color: gray,
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: setting.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (index == 0) {
                      // // logout secara server
                      // auth.signOut();
                      // // logout dari sisi local
                      // Navigator.pushReplacement(
                      //     context,
                      //     CupertinoPageRoute(
                      //       builder: (context) => Login(),
                      //     ));
                      // batas
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Apakah anda ingin meninggalkan aplikasi?',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Tidak'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Ya'),
                                  onPressed: () {
                                    auth.signOut();

                                    // logout dari sisi local
                                    Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => Login(),
                                        ));
                                  },
                                ),
                              ],
                            );
                          });
                      //batas
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: Row(
                      children: [
                        FaIcon(
                          setting[index].icon,
                          size: 23,
                          color: navy,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          setting[index].title,
                          style: text16_4navy,
                        )
                      ],
                    ),
                  ),
                );
              },
            ))
          ],
        );
      },
    );
  }
}
