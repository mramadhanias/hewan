import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductData {
  final String id;
  final String image;
  final String name;
  final String price;
  final String desc;
  final String stock;
  const ProductData(
      {required this.id,
      required this.image,
      required this.name,
      required this.price,
      required this.desc,
      required this.stock});
}

class Setting {
  final IconData icon;
  final String title;
  final Widget widget;
  const Setting(
      {required this.icon, required this.title, required this.widget});
}

List<Setting> setting = [
  const Setting(
      icon: FontAwesomeIcons.cartShopping,
      title: "Keranjang",
      widget: Center()),
  const Setting(
      icon: FontAwesomeIcons.heart, title: "Whitelist", widget: Center()),
  const Setting(
      icon: FontAwesomeIcons.faceGrinHearts,
      title: "Followers",
      widget: Center()),
  const Setting(
      icon: FontAwesomeIcons.circleInfo,
      title: "Info terkini",
      widget: Center()),
  const Setting(
      icon: FontAwesomeIcons.circleQuestion,
      title: "Bantuan cs",
      widget: Center()),
  const Setting(
      icon: FontAwesomeIcons.rightFromBracket,
      title: "Logout",
      widget: Center()),
];
