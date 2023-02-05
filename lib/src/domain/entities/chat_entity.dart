import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String fromId;
  final String toId;
  final String fromName;
  final String toName;
  final String fromAvatar;
  final String toAvatar;
  final String lastMsg;
  final Timestamp lastTime;
  final int msgNum;

  Chat({
    required this.fromId,
    required this.toId,
    required this.fromName,
    required this.toName,
    required this.fromAvatar,
    required this.toAvatar,
    required this.lastMsg,
    required this.lastTime,
    required this.msgNum,
  });
}
