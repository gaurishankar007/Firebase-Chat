import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/domain/entities/chat_entity.dart';

class ChatModel extends Chat {
  const ChatModel({
    required String fromId,
    required String toId,
    required String fromName,
    required String toName,
    required String fromAvatar,
    required String toAvatar,
    required String lastMsg,
    required Timestamp lastTime,
    required int msgNum,
  }) : super(
          fromId: fromId,
          toId: toId,
          fromName: fromName,
          toName: toName,
          fromAvatar: fromAvatar,
          toAvatar: toAvatar,
          lastMsg: lastMsg,
          lastTime: lastTime,
          msgNum: msgNum,
        );

  factory ChatModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return ChatModel(
      fromId: data['fromId'] as String,
      toId: data['toId'] as String,
      fromName: data['fromName'] as String,
      toName: data['toName'] as String,
      fromAvatar: data['fromAvatar'] as String,
      toAvatar: data['toAvatar'] as String,
      lastMsg: data['lastMsg'] as String,
      lastTime: data['lastTime'] as Timestamp,
      msgNum: data['msgNum'] as int,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "fromId": fromId,
      "toId": toId,
      "fromName": fromName,
      "toName": toName,
      "fromAvatar": fromAvatar,
      "toAvatar": toAvatar,
      "lastMsg": lastMsg,
      "lastTime": lastTime,
      "msgNum": msgNum,
    };
  }
}
