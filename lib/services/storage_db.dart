import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/ui/widgets/loading.dart';

class StorageDB {

  final _db = FirebaseStorage.instance;

  Future<String> uploadImage(String user, File file) async {
    loading();
    final metaData = SettableMetadata(customMetadata: {'user': user});
    final ref = _db.ref().child('images/${file.path}');
    final task = ref.putFile(file, metaData);
    final snaphot = await task.whenComplete(() {});
    final url = await snaphot.ref.getDownloadURL();
    return url;
  }

}