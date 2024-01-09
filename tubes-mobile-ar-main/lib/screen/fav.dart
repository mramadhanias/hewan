import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_market_hewan/data/data.dart';
import 'package:tubes_market_hewan/screen/product_detail.dart';
import 'package:tubes_market_hewan/style/custom_container.dart';
import 'package:tubes_market_hewan/style/text.dart';

class Fav extends StatefulWidget {
  const Fav({super.key});

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: StreamBuilder(
          stream: db
              .collection("userData")
              .doc(uid)
              .collection("favProduct")
              .snapshots(),
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
            var data = snapshot.data!.docs;
            // print("manuok : ${data[0].}");
            return GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 230.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                // return Text(data[index]['name']);
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetail(
                              data: ProductData(
                                  id: data[index].id,
                                  image: data[index]['image'],
                                  name: data[index]['name'],
                                  price: data[index]['price'],
                                  desc: data[index]['desc'],
                                  stock: data[index]['stock'])),
                        ));
                  },
                  child: Container(
                    decoration: cardContainer,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Color.fromARGB(207, 109, 72, 72),
                        Color.fromRGBO(97, 96, 86, 0.596)
                      ], begin: Alignment.topLeft, end: Alignment.topRight)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150,
                            width: mediaQuery.size.width / 2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(data[index]['image']),
                                  fit: BoxFit.cover),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]['name'],
                                  style: text12_6navy,
                                ),
                                Text(
                                  "Rp ${data[index]['price']}",
                                  style: text14_6navy,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
