import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String uId;
  final String content;
  final String type;
  final Timestamp createdAt;

  Message({
    required this.uId,
    required this.content,
    required this.type,
    required this.createdAt,
  });
}
