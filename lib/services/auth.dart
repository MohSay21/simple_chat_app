import 'package:chat_app/services/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/ui/widgets/loading.dart';
import 'package:chat_app/main.dart';

class Authentication {

  Authentication(this.context);

  final _auth = FirebaseAuth.instance;
  final BuildContext context;

  Future signIn(String email, String password) async {
    loading();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex) {
      if (ex.message != null) {
        _showMessage(ex.message!);
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future signUp(String email, String password) async {
    loading();
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex) {
      if (ex.message != null) {
        _showMessage(ex.message!);
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future resetPassword(String email) async {
    loading();
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch(ex) {
      if (ex.message != null) {
        _showMessage(ex.message!);
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  _showMessage(String message) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      backgroundColor: mainColor,
      elevation: 0,
    )
  );

}