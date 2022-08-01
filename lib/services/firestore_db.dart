import 'dart:async';
import 'package:chat_app/main.dart';
import 'package:chat_app/ui/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

class FirestoreDB {

  final _collection = FirebaseFirestore.instance.collection('users');

  Future setUser(MyUser user) async {
    final doc = _collection.doc(user.email);
    await doc.set(user.toJSON());
  }

  Future<MyUser> getUser(String email) async {
    final doc = _collection.doc(email);
    final snapshot = await doc.get();
    final user = MyUser.fromJSON(snapshot.data()!);
    return user;
  }

  Future<List<MyUser>> getUsers() async {
     final docs = await _collection.get();
     final users = docs.docs.map((user) => MyUser.fromJSON(user.data())).toList();
     return users;
  }

  Stream<List<Message>> getMessages(String sender, String receiver) async* {
    final collection = _collection.doc(sender).collection('messages')
        .where('receiver', isEqualTo: receiver)
        .orderBy('time', descending: true);
    await for (var snapshot in collection.snapshots()) {
      final messages = snapshot.docs.map((message) =>
          Message.fromJSON(message.data()));
      yield messages.toList();
    }
  }
    

  Future<void> setMessage(Message message) async {
    final collection = _collection.doc(message.sender).collection('messages');
    await collection.doc().set(message.toJSON(message));
  }

  Future deleteUser(String email) async {
    loading();
    final doc = _collection.doc(email);
    final messagesDocs = await doc.collection('messages').get();
    for (int i = 0; i < messagesDocs.size; i++) {
      doc.collection('messages').doc(messagesDocs.docs[i].id).delete();
    }
    await doc.delete();
    final docs = await _collection.get();
      final users = docs.docs.map((user) => MyUser.fromJSON(user.data())).toList();
      for (int i = 0; i < users.length; i++) {
        final ref = _collection.doc(users[i].email).collection('messages');
        final docs = await ref.get();
        for (int j = 0; j < docs.size; j++) {
          final receiver = Message.fromJSON(docs.docs[j].data()).receiver;
          if (receiver == email) {
            await ref.doc(docs.docs[j].id).delete();
          }
        }
      }
    navigatorKey.currentState!.pop();
  }

  Future deleteMessage(Message message) async {
    final ref = _collection.doc(message.sender).collection('messages');
    final docs = await ref.get();
    for (int i = 0; i < docs.size; i++) {
      await ref.doc(docs.docs[i].id).delete();
    }
  }

}