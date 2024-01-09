import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_market_hewan/data/data.dart';
import 'package:tubes_market_hewan/screen/payment.dart';
import 'package:tubes_market_hewan/screen/product_update.dart';
import 'package:tubes_market_hewan/style/color.dart';
import 'package:tubes_market_hewan/style/custom_container.dart';
import 'package:tubes_market_hewan/style/text.dart';

class ProductDetail extends StatefulWidget {
  final ProductData data;
  const ProductDetail({super.key, required this.data});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      size: 20,
                      color: navy,
                    ),
                  ),
                  const Spacer(),
                  StreamBuilder(
                      stream: db.collection("userData").doc(uid).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error"),
                          );
                        }
                        var data = snapshot.data!.data();
                        if (data?['role'] == "admin") {
                          return Row(
                            children: [
                              InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ProductUpdate(
                                          data: widget.data,
                                        ),
                                      )),
                                  onLongPress: () async {
                                    await db
                                        .collection("product")
                                        .doc(widget.data.id)
                                        .delete();
                                    Navigator.pop(context);
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.solidPenToSquare,
                                    size: 20,
                                    color: navy,
                                  )),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                  const SizedBox(
                    width: 15,
                  ),
                  const FaIcon(
                    FontAwesomeIcons.solidShareFromSquare,
                    size: 20,
                    color: navy,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const FaIcon(
                    FontAwesomeIcons.bagShopping,
                    size: 20,
                    color: navy,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: mediaQuery.size.height / 2.5,
              width: mediaQuery.size.width,
              child: Image.network(
                widget.data.image,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rp ${widget.data.price}",
                            style: text18_6navy,
                          ),
                          StreamBuilder(
                              stream: db
                                  .collection("userData")
                                  .doc(uid)
                                  .collection("favProduct")
                                  .where("id", isEqualTo: widget.data.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text("e"),
                                  );
                                }
                                var data = snapshot.data?.docs;
                                print("masnukkk : ${data}");
                                // print("masnukkk : ${data?[0]['id']}");
                                return InkWell(
                                    onTap: () async {
                                      if (data.isNotEmpty) {
                                        await db
                                            .collection("userData")
                                            .doc(uid)
                                            .collection("favProduct")
                                            .doc(widget.data.id)
                                            .delete();
                                      } else {
                                        print('aktif');
                                        await db
                                            .collection("userData")
                                            .doc(uid)
                                            .collection("favProduct")
                                            .doc(widget.data.id)
                                            .set({
                                          'id': widget.data.id,
                                          'name': widget.data.name,
                                          'image': widget.data.image,
                                          'price': widget.data.price,
                                          'stock': widget.data.stock,
                                          'desc': widget.data.desc,
                                        });
                                      }
                                    },
                                    child: FaIcon(
                                      data!.isNotEmpty
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      size: 20,
                                    ));
                              })
                        ],
                      ),
                      Text(
                        widget.data.name,
                        style: text14_4navy,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.data.desc,
                        style: text14_4navy,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20.0),
        child: Row(children: [
          Container(
            height: 50,
            width: 50,
            decoration: boxWhiteBorderRounded,
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.comment,
                size: 20,
                color: navy,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const Payment(),
                    ));
              },
              child: Container(
                height: 50,
                decoration: boxNavyRounded,
                child: Center(
                    child: Text(
                  "Buy Now",
                  style: text14_6white,
                )),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
