import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String uId;
  final String content;
  final MessageType type;
  final Timestamp createdAt;

  Message({
    required this.uId,
    required this.content,
    required this.type,
    required this.createdAt,
  });
}

enum MessageType {
  text,
  image,
}
