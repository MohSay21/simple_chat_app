import 'dart:io';
import 'package:chat_app/custom_icons.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/firestore_db.dart';
import 'package:chat_app/services/gallery.dart';
import 'package:chat_app/services/storage_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfile extends ConsumerStatefulWidget {

  const EditProfile({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _EditProfileState();

}

class _EditProfileState extends ConsumerState<EditProfile> {

  final _firestoreDB = FirestoreDB();
  final _storageDB = StorageDB();
  final GlobalKey<FormState> _nameK = GlobalKey<FormState>();
  File? image;
  String name = '';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(myUserP);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.clear, color: theme.colorScheme.secondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(CustomIcons.check, color: theme.colorScheme.secondary),
            onPressed: () async {
              if (_nameK.currentState!.validate()) {
                String url = '';
                if (image != null) {
                  url = await _storageDB.uploadImage(name, image!);
                }
                ref.read(myUserP.notifier).changeUser(
                  name: name,
                  image: url.isEmpty ? user.image : url,
                );
                await _firestoreDB.setUser(ref.watch(myUserP));
                navigatorKey.currentState!.pop();
            }
            },
          ),
        ],
      ),
      body: Form(
          key: _nameK,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: size.height / 7),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: size.height / 120,
                        right: size.width / 4,
                      ),
                      child: const Text(
                        'Profile picture',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: size.width / 2 + 20,
                      width: size.width / 2 + 20,
                    ),
                    GestureDetector(
                      onTap: () => _selectImage(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(size.width / 4),
                        child: image != null
                        ? Image.file(
                          image!,
                          width: size.width / 2,
                          height: size.width / 2,
                          fit: BoxFit.cover,
                        )
                        : user.image.isEmpty
                            ? Image.asset(
                          'assets/profile_pic.webp',
                          width: size.width / 2,
                          height: size.width / 2,
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          user.image,
                          width: size.width / 2,
                          height: size.width / 2,
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                    Positioned(
                      right: size.width / 18,
                      bottom: size.width / 18,
                      child: GestureDetector(
                        onTap: () => _selectImage(),
                        child: CircleAvatar(
                            radius: size.width / 18,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: size.height / 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          'User-name',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      TextFormField(
                        validator: (value) => value!.length < 3
                        ? 'User-name must be at least 3 characters long!'
                        : null,
                        onChanged: (value) => setState(() => name = value),
                        initialValue: user.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.edit),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
          ),
      ),
    );
  }

  void _selectImage() async {
    final result = await pickImage();
    if (result == null) return;
    setState(() => image = result);
  }

}