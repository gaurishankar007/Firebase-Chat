import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String fromId;
  final String toId;
  final String fromName;
  final String toName;
  final String fromAvatar;
  final String toAvatar;
  final String lastMsg;
  final Timestamp lastTime;
  final int msgNum;

  const Chat({
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

  @override
  List<Object?> get props => [
        fromId,
        toId,
        fromName,
        fromAvatar,
        toAvatar,
        lastMsg,
        lastTime,
      ];
}
