import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/firestore_db.dart';

final _firestoreDB = FirestoreDB();

final usersP = FutureProvider.autoDispose<List<MyUser>>(
    (ref) async => await getUsers()
);

Future<List<MyUser>> getUsers() async => await _firestoreDB.getUsers();