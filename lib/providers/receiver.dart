import 'package:flutter_riverpod/flutter_riverpod.dart';

final receiverP = StateNotifierProvider<ReceiverN, String>(
    (ref) => ReceiverN()
);

class ReceiverN extends StateNotifier<String> {

  ReceiverN() : super('');

  void changeState(String receiver) {
    String newState = state;
    newState = receiver;
    state = newState;
  }

}