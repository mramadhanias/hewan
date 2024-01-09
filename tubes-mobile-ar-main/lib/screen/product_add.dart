import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_market_hewan/style/color.dart';
import 'package:tubes_market_hewan/style/custom_container.dart';
import 'package:tubes_market_hewan/style/text.dart';
import 'package:uuid/uuid.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  File? _image;
  final picker = ImagePicker();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController desckController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImageToFirebase(String id) async {
    if (_image != null) {
      Reference ref = FirebaseStorage.instance.ref().child('product/$id');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String imageURL = await storageTaskSnapshot.ref.getDownloadURL();
      print('Image URL: $imageURL');
      return imageURL;
    } else {
      print('No image selected.');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    bool isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image != null
                  ? InkWell(
                      onTap: getImage,
                      child: Image.file(
                        _image!,
                        height: isKeyboardVisible ? 50 : 200,
                        width: isKeyboardVisible
                            ? mediaQuery.size.width / 5
                            : mediaQuery.size.width / 1.2,
                        fit: BoxFit.cover,
                      ),
                    )
                  : InkWell(
                      onTap: getImage,
                      child: const Text('No image, click to select image')),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: getImage,
              //   child: const Text('Select Image'),
              // ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                decoration: boxWhiteBorderRounded,
                child: TextField(
                  controller: nameController,
                  style: text14_6navy,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: InputBorder.none,
                    prefixIcon: FaIcon(
                      FontAwesomeIcons.paragraph,
                      size: 18,
                      color: navy.withOpacity(0.5),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 35,
                      minHeight: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                decoration: boxWhiteBorderRounded,
                child: TextField(
                  controller: priceController,
                  style: text14_6navy,
                  decoration: InputDecoration(
                    hintText: 'Price',
                    border: InputBorder.none,
                    prefixIcon: FaIcon(
                      FontAwesomeIcons.moneyBill,
                      size: 18,
                      color: navy.withOpacity(0.5),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 35,
                      minHeight: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                decoration: boxWhiteBorderRounded,
                child: TextField(
                  controller: stockController,
                  style: text14_6navy,
                  decoration: InputDecoration(
                    hintText: 'Stock',
                    border: InputBorder.none,
                    prefixIcon: FaIcon(
                      FontAwesomeIcons.boxesStacked,
                      size: 18,
                      color: navy.withOpacity(0.5),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 35,
                      minHeight: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                // height: 50,
                decoration: boxWhiteBorderRounded,
                child: TextFormField(
                  maxLines: 5,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  controller: desckController,
                  style: text14_6navy,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: InputBorder.none,
                    prefixIcon: FaIcon(
                      FontAwesomeIcons.tag,
                      size: 18,
                      color: navy.withOpacity(0.5),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 35,
                      minHeight: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  String productID = const Uuid().v4();
                  if (_image != null) {
                    String url = await uploadImageToFirebase(productID);
                    final db = FirebaseFirestore.instance;
                    db.collection("product").doc(productID).set({
                      "image": url,
                      "name": nameController.text,
                      "stock": stockController.text,
                      "desc": desckController.text,
                      "price": priceController.text
                    });
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: mediaQuery.size.width,
                  height: 50,
                  decoration: boxNavyRounded,
                  child: Center(
                      child: Text(
                    "Add",
                    style: text14_6white,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
