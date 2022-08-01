import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/services/firestore_db.dart';
import 'package:chat_app/providers/receiver.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/models/message.dart';

final _firestoreDB = FirestoreDB();
final _auth = FirebaseAuth.instance;

final senderMessagesP = StreamProvider<List<Message>>(
    (ref) => getMessages(ref.watch(myUserP).email, ref.watch(receiverP))
);
final receiverMessagesP = StreamProvider<List<Message>>(
    (ref) => getMessages(ref.watch(receiverP), _auth.currentUser!.email!)
);

Stream<List<Message>> getMessages(String sender, String receiver) =>
  _firestoreDB.getMessages(sender, receiver);