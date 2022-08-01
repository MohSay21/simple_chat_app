import 'package:chat_app/services/firestore_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/models/user.dart';

final _firestoreDB = FirestoreDB();

final myUserP = StateNotifierProvider<MyUserN, MyUser>(
    (ref) => MyUserN()
);
final getUserP = FutureProvider.autoDispose.family<MyUser, String>(
    (ref, email) async => await getUser(email)
);

class MyUserN extends StateNotifier<MyUser> {

  MyUserN() : super(MyUser.initial());

  void changeUser({
  String? name,
  String? email,
  String? image,
}) {
    MyUser newState = state.copy(
      name: name,
      email: email,
      image: image,
    );
    state = newState;
  }

  Future<void> setUser(MyUser user) async {
    MyUser newState = state;
    await _firestoreDB.setUser(user);
    newState = user;
    state = newState;
  }

}

Future<MyUser> getUser(String email) async =>
    await _firestoreDB.getUser(email);