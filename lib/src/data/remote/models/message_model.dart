import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/domain/entities/message_entity.dart';

class MessageModel extends Message {
  MessageModel({
    required String uId,
    required String content,
    required MessageType type,
    required Timestamp createdAt,
  }) : super(
          uId: uId,
          content: content,
          type: type,
          createdAt: createdAt,
        );

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    final MessageType type =
        data['type'] == "text" ? MessageType.text : MessageType.image;

    return MessageModel(
      uId: data['uId'] as String,
      content: data['content'] as String,
      type: type,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    final String newType = type == MessageType.text ? "text" : "image";

    return {
      "uId": uId,
      "content": content,
      "type": newType,
      "createdAt": createdAt,
    };
  }
}
