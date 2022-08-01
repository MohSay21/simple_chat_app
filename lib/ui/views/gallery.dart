import 'dart:io';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/providers/password.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/storage_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/services/gallery.dart';
import 'package:chat_app/services/theme.dart';

class GalleryV extends ConsumerStatefulWidget {

  const GalleryV({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _GalleryVState();

}

class _GalleryVState extends ConsumerState {

  File? image;

  @override
  Widget build(BuildContext context) {
    final storageDB = StorageDB();
    final auth = Authentication(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          children: [
            SizedBox(height: size.height / 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(size.width / 5),
              child: image == null
                  ? Image.asset(
                'assets/profile_pic.webp',
                width: size.width / 2.5,
                height: size.width / 2.5,
                fit: BoxFit.cover,
              )
                  : Image.file(
                image!,
                width: size.width / 2.5,
                height: size.width / 2.5,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: size.height / 10),
            const Text(
              'Select a profile picture',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: size.height / 20),
            ElevatedButton(
              onPressed: () async {
                final result = await pickImage();
                if (result == null) return;
                setState(() => image = result);
              },
              style: ElevatedButton.styleFrom(
                primary: mainColor,
                elevation: 0,
                fixedSize: Size(size.width / 2.5, size.height / 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'From gallery',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: size.height / 20),
            image == null
            ? ElevatedButton(
              onPressed: () async => await _creatingUser(ref, auth),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                elevation: 0,
                fixedSize: Size(size.width / 4, size.height / 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
            )
            : ElevatedButton(
              onPressed: () async {
                final url = await storageDB.uploadImage(ref.watch(myUserP).name, image!);
                ref.read(myUserP.notifier).changeUser(image: url);
                await _creatingUser(ref, auth);
              },
              style: ElevatedButton.styleFrom(
                primary: mainColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: Size(size.width / 4, size.height / 15),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Future<void> _creatingUser(WidgetRef ref, Authentication auth) async {
    final user = ref.watch(myUserP);
    await ref.read(myUserP.notifier).setUser(user);
    await auth.signUp(
        user.email, ref.watch(passwordP)
    );

  }

}