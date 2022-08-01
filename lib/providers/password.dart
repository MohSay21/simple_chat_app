import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordP = StateNotifierProvider<PasswordN, String>(
    (ref) => PasswordN()
);

class PasswordN extends StateNotifier<String> {

  PasswordN() : super('');

  void changeState(String newPassword) {
    String newState = state;
    newState = newPassword;
    state = newState;
  }

}