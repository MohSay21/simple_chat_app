import 'package:chat_app/custom_icons.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/user.dart';
import'package:chat_app/providers/messages.dart';
import 'package:chat_app/providers/receiver.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/firestore_db.dart';
import 'package:chat_app/services/gallery.dart';
import 'package:chat_app/services/storage_db.dart';
import 'package:chat_app/ui/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/services/theme.dart';
import 'package:chat_app/ui/widgets/loading.dart';
import 'package:chat_app/services/functions.dart';
import 'package:chat_app/models/message.dart';
import 'package:intl/intl.dart';

class ChatV extends ConsumerStatefulWidget {

  const ChatV({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ChatVState();

}

class _ChatVState extends ConsumerState<ChatV> {

  final _firestoreDB = FirestoreDB();
  final _storageDB = StorageDB();
  final _messageCtrl = TextEditingController();
  bool _isValid = false;
  bool _showDate = false;
  int _dateIdx = 0;
  String? previous;
  final _dateFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final user = ref.watch(myUserP);
    MyUser receiver = MyUser.initial();
    ref.watch(getUserP(ref.watch(receiverP))).whenData((data) => receiver = data);
    final streamSender = ref.watch(senderMessagesP);
    final streamReceiver = ref.watch(receiverMessagesP);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          receiver.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => navigatorKey.currentState!.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width / 20),
          child: Column(
            children: [
              Expanded(
                child: streamSender.when(
                loading: () => loading(),
                error: (ex, stack) => Center(child: Text(ex.toString())),
                data: (senderMessages) => streamReceiver.when(
                  loading: () => loading(),
                  error: (ex, stack) => Center(child: Text(ex.toString())),
                  data: (receiverMessages) {
                    List<Message> messages = senderMessages + receiverMessages;
                    sortList(messages);
                    if (messages.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: size.height / 20),
                        child: Text(
                          'You are friends on Chat app',
                          style: TextStyle(
                            fontSize: size.width / 20,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      key: PageStorageKey<String>('messages'),
                      reverse: true,
                      padding: EdgeInsets.only(top: size.height / 60),
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int idx) {
                        bool isPreviousSame = messages[idx].sender == previous;
                        previous = messages[idx].sender;
                          return messages[idx].sender == user.email
                              ? Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height / 130),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      isPreviousSame
                                      ? SizedBox(width: size.width / 10)
                                      : userImage(size.width / 10, user.image),
                                      SizedBox(width: size.width / 50),
                                      GestureDetector(
                                            onTap: () =>
                                                setState(() {
                                                  _showDate = !_showDate;
                                                  _dateIdx = idx;
                                                }),
                                        onLongPress: () async => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: theme.scaffoldBackgroundColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            title: Text(
                                              'Delete message',
                                              style: TextStyle(
                                                color: theme.colorScheme.secondary,
                                                fontSize: 18,
                                              ),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete this message?',
                                              style: TextStyle(
                                                color: theme.colorScheme.secondary,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    navigatorKey.currentState!.pop(),
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await _firestoreDB.deleteMessage(messages[idx]);
                                                  navigatorKey.currentState!.pop();
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                            child: messages[idx].type == 'message'
                                                ? Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: size.width / 20,
                                                vertical: size.width / 30,
                                              ),
                                              decoration: BoxDecoration(
                                                color: mainColor,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(size.width / 10),
                                                  bottomLeft: Radius.circular(size.width / 10),
                                                  bottomRight: Radius.circular(size.width / 10),
                                                ),
                                              ),
                                              child: Text(
                                                messages[idx].message,
                                                style: TextStyle(
                                                  color: theme.colorScheme
                                                      .secondary,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                        : ClipRRect(
                                              borderRadius: BorderRadius.circular(size.width / 25),
                                              child: Image.network(
                                                messages[idx].message,
                                                width: size.width / 2,
                                                height: size.width / 2,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                  _showDate && _dateIdx == idx
                                      ? Padding(
                                    padding: EdgeInsets.only(
                                      right: size.width / 2,
                                      top: size.height / 150,
                                    ),
                                    child: Text(
                                      _dateFormat.format(messages[idx].time)
                                          .toString(),
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  )
                                      : SizedBox(height: isPreviousSame ? 1 : size.height / 60),
                                ],
                              ),
                            ),
                          )
                              : Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height / 130),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                          GestureDetector(
                                            onTap: () =>
                                                setState(() {
                                                  _showDate = !_showDate;
                                                  _dateIdx = idx;
                                                }),
                                            onLongPress: () async => showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: theme.scaffoldBackgroundColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)
                                                ),
                                                title: Text(
                                                  'Delete message',
                                                  style: TextStyle(
                                                    color: theme.colorScheme.secondary,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete this message?',
                                                  style: TextStyle(
                                                    color: theme.colorScheme.secondary,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        navigatorKey.currentState!.pop(),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: mainColor,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await _firestoreDB.deleteMessage(messages[idx]);
                                                      navigatorKey.currentState!.pop();
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: mainColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: messages[idx].type == 'message'
                                                ? Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: size.width / 20,
                                                vertical: size.width / 30,
                                              ),
                                              decoration: BoxDecoration(
                                                color: ref.watch(isDarkP)
                                                    ? Colors.grey.shade700.withOpacity(0.7)
                                                    : Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(size.width / 10),
                                                  bottomRight: Radius.circular(size.width / 10),
                                                  bottomLeft: Radius.circular(size.width / 10),
                                                ),
                                              ),
                                              child: Text(
                                                messages[idx].message,
                                                style: TextStyle(
                                                  color: theme.colorScheme
                                                      .secondary,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                            : ClipRRect(
                                              borderRadius: BorderRadius.circular(size.width / 25),
                                              child: Image.network(
                                                messages[idx].message,
                                                width: size.width / 2,
                                                height: size.width / 2,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      SizedBox(width: size.width / 50),
                                      isPreviousSame
                                      ? SizedBox(width: size.width / 10)
                                      : userImage(size.width / 10, receiver.image),
                                    ],
                                  ),
                                  _showDate && _dateIdx == idx
                                      ? Padding(
                                    padding: EdgeInsets.only(
                                      left: size.width / 2,
                                      top: size.height / 150,
                                    ),
                                    child: Text(
                                      _dateFormat.format(messages[idx].time)
                                          .toString(),
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  )
                                      : SizedBox(height: isPreviousSame ? 1 : size.height / 50),
                                ],
                              ),
                            ),
                          );
                        },
                          );
                  },
                ),
                ),
              ),
              SizedBox(height: size.height / 100),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageCtrl,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      maxLines: 3,
                      minLines: 1,
                      onChanged: (String? value) {
                        if (value != null && value.isNotEmpty) {
                          setState(() => _isValid = true);
                        } else if (value == null || value.isEmpty) {
                          setState(() => _isValid = false);
                        }
                      },
                      onEditingComplete: () {
                        if (_messageCtrl.text.isNotEmpty) {
                          setState(() => _isValid = true);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: size.width / 18 + 1,
                    backgroundColor: _isValid ? mainColor : Colors.grey,
                    child: Container(
                      width: size.width / 9,
                      height: size.width / 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width / 18),
                        color: theme.scaffoldBackgroundColor,
                      ),
                      child: _isValid ?
                      IconButton(
                        onPressed: () async {
                          final message = _messageCtrl.text;
                          _messageCtrl.clear();
                          FocusScope.of(context).unfocus();
                          setState(() => _isValid = false);
                          await _firestoreDB.setMessage(Message(
                            sender: user.email,
                            receiver: receiver.email,
                            time: DateTime.now(),
                            message: message,
                            type: 'message',
                          ));
                          },
                        icon: Icon(
                          Icons.arrow_upward,
                          color: mainColor,
                          size: 28,
                        )
                      )
                      : IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CustomIcons.keyboard_voice,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: size.width / 18 + 1,
                    backgroundColor: Colors.grey,
                    child: Container(
                      width: size.width / 9,
                      height: size.width / 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width / 18),
                        color: theme.scaffoldBackgroundColor,
                      ),
                      child: IconButton(
                      onPressed: () async {
                        final file = await pickImage();
                        if (file == null) return;
                        final url = await _storageDB.uploadImage(user.name, file);
                        final message = Message(
                          sender: user.email,
                          receiver: receiver.email,
                          message: url,
                          type: 'image',
                          time: DateTime.now(),
                        );
                        await _firestoreDB.setMessage(message);
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey,
                        size: 28,
                      ),
                  ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height / 80),
            ],
          ),
        ),
      ),
    );
  }

}