import 'package:chat_app/models/message.dart';

void sortList(List<Message> list) {
  list.sort((x, y) {
    final result = x.time.millisecondsSinceEpoch > y.time.millisecondsSinceEpoch;
    switch (result) {
      case true: return -1;
      case false: return 1;
      default: return 0;
    }
  });
}