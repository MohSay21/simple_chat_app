import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/ui/views/home.dart';
import 'package:chat_app/ui/views/signin.dart';
import 'package:chat_app/ui/widgets/loading.dart';

class MainV extends StatelessWidget {

  MainV({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else if (snapshot.hasData) {
              return HomeV();
            } else {
              return SignInV();
            }
          }
      ),
    );
  }

}