import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      return file;
    }
  } on PlatformException catch (ex) {
    print(ex.toString());
  }
}