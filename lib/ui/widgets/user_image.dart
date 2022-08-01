import 'package:flutter/material.dart';

Widget userImage(double size, String image) => ClipRRect(
  borderRadius: BorderRadius.circular(size / 2),
  child: image.isNotEmpty
  ? Image.network(
    image,
    width: size,
    height: size,
    fit: BoxFit.cover,
  )
  : Image.asset(
    'assets/profile_pic.webp',
    width: size,
    height: size,
    fit: BoxFit.cover,
  ),
);