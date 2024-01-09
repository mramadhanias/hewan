import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tubes_market_hewan/data/data.dart';
import 'package:tubes_market_hewan/screen/product_detail.dart';
import 'package:tubes_market_hewan/style/color.dart';
import 'package:tubes_market_hewan/style/custom_container.dart';
import 'package:tubes_market_hewan/style/text.dart';

import 'dart:developer';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final db = FirebaseFirestore.instance;
  TextEditingController? searchController = TextEditingController();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var searchName = "";
  bool isVisible = false;
  bool isDescending = true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              height: 50,
              decoration: boxWhiteBorderRounded,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchName = value;
                  });
                },
                controller: searchController,
                style: text14_6navy,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: const FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 18,
                    color: navy,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 35,
                    minHeight: 15,
                  ),
                  suffixIcon: InkWell(
                    onTap: () => setState(() {
                      isDescending = !isDescending;
                    }),
                    child: FaIcon(
                      isDescending
                          ? FontAwesomeIcons.filterCircleDollar
                          : FontAwesomeIcons.filter,
                      size: 18,
                      color: navy,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 35,
                    minHeight: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                  height: 300,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildQrView(context, controller)),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: db
                      .collection("product")
                      .where("name", isGreaterThanOrEqualTo: searchName)
                      .where("name", isLessThanOrEqualTo: "$searchName\uf7ff")
                      .orderBy("name", descending: isDescending)
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
                    return GridView.builder(
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 150,
                                  width: mediaQuery.size.width / 2,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(data[index]['image']),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isVisible = !isVisible;
          });
        },
        backgroundColor: navy,
        mini: true,
        child: const FaIcon(
          FontAwesomeIcons.qrcode,
          color: white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context, QRViewController? controller) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 180.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: const FaIcon(
                  FontAwesomeIcons.bolt,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await controller?.flipCamera();
                setState(() {});
              },
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: const FaIcon(
                  FontAwesomeIcons.rotate,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        searchController?.text = result!.code.toString();
        // controllerInput?.text = "hmmm";
        // print("test");
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
