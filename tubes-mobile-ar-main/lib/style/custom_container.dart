import 'package:flutter/material.dart';
import 'package:tubes_market_hewan/style/color.dart';

BoxDecoration boxWhiteBorderRounded = BoxDecoration(
    border: Border.all(color: navy, width: 1.0),
    borderRadius: BorderRadius.circular(30));

// BoxDecoration boxWhiteBorderCircular = BoxDecoration(
//     border: Border.all(color: navy, width: 1.0),
//     borderRadius: BorderRadius.circular(30));

BoxDecoration boxNavyRounded =
    BoxDecoration(color: navy, borderRadius: BorderRadius.circular(30));

BoxDecoration cardContainer = BoxDecoration(
  color: white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2), // Warna bayangan
      spreadRadius: 0, // Lebar bayangan yang menyebar
      blurRadius: 5,
      offset: const Offset(3, 3),
    ),
  ],
);

BoxDecoration cardContainer2 = BoxDecoration(
  color: white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.07), // Warna bayangan
      spreadRadius: 0, // Lebar bayangan yang menyebar
      blurRadius: 5,
      offset: const Offset(3, 3),
    ),
  ],
);
