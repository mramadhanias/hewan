import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_market_hewan/data/data.dart';
import 'package:tubes_market_hewan/screen/product_detail.dart';
import 'package:tubes_market_hewan/style/color.dart';
import 'package:tubes_market_hewan/style/custom_container.dart';
import 'package:tubes_market_hewan/style/text.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final db = FirebaseFirestore.instance;

  final List<IconData> iconData = [
    FontAwesomeIcons.hippo,
    FontAwesomeIcons.horse,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.fish,
    FontAwesomeIcons.frog,
  ];

  final List<String> titleData = [
    "Badak",
    "Kuda",
    "Anjing",
    "Kucing",
    "Ikan",
    "Kodok",
  ];
  String kucing = '';
  bool isKucing = true;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.dove,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Fauna Store",
                style: text25_5navy,
              ),
              const Spacer(),
              const FaIcon(
                FontAwesomeIcons.solidEnvelopeOpen,
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
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: mediaQuery.size.width,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 5.0),
                        child: Text(
                          "Categori",
                          style: text16_6navy,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: mediaQuery.size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: iconData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (index == 3) {
                                  setState(() {
                                    kucing == "kucing"
                                        ? kucing = ""
                                        : kucing = "kucing";
                                    isKucing = !isKucing;
                                  });
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FaIcon(
                                      iconData[index],
                                      color: navy,
                                    ),
                                    Text(
                                      titleData[index],
                                      style: text12_4navy,
                                    )
                                  ],
                                )),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  height: 150,
                  width: mediaQuery.size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=1472&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "",
                    style: text16_6navy,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  height: 210,
                  child: StreamBuilder(
                      stream: db.collection("product").snapshots(),
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
                        var data = snapshot.data!.docs;
                        return GridView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: 210.0,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemBuilder: (context, index) {
                            // return Text(data[index]['name']);
                            if (isKucing) {
                              if (data[index]['name']
                                  .toString()
                                  .contains("kucing")) {
                                print("return");
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
                                    decoration: cardContainer2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 150,
                                          width: mediaQuery.size.width / 2,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    data[index]['image']),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                );
                              }
                              return SizedBox();
                            }
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
                                decoration: cardContainer2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 130,
                                      width: mediaQuery.size.width / 2,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                data[index]['image']),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                            );
                          },
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Diskon",
                    style: text16_6navy,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  height: 130,
                  child: StreamBuilder(
                      stream: db
                          .collection("product")
                          .limit(3)
                          .orderBy("price", descending: true)
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
                            child: Text("Error"),
                          );
                        }
                        var data = snapshot.data!.docs;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: 210.0,
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
                                decoration: cardContainer2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 130,
                                      width: mediaQuery.size.width / 2,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                data[index]['image']),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
