import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {

  final String sender;
  final String receiver;
  final DateTime time;
  final String message;
  final String type;

  const Message({
    required this.sender,
    required this.receiver,
    required this.time,
    required this.message,
    required this.type,
});

  factory Message.initial() => Message(
      sender: '',
      receiver: '',
      time: DateTime.now(),
      message: '',
      type: 'message',
  );

  Message copy({
  String? sender,
  String? receiver,
  DateTime? time,
  String? message,
  bool? seen,
  String? type,
}) => Message(
    sender: sender ?? this.sender,
    receiver: receiver ?? this.receiver,
    time: time ?? this.time,
    message: message ?? this.message,
    type: type ?? this.type,
  );

  factory Message.fromJSON(Map<String, dynamic> json) => Message(
    sender: json["sender"],
    receiver: json["receiver"],
    time: json["time"].toDate(),
    message: json["message"],
    type: json["type"],
  );

  Map<String, dynamic> toJSON(Message message) => {
    "sender": message.sender,
    "receiver": message.receiver,
    "time": Timestamp.fromDate(message.time),
    "message": message.message,
    "type": message.type,
  };

  @override
  List<Object?> get props => [sender, receiver, time, message, type];

}