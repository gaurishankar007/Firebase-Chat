import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/domain/entities/user_entity.dart';

class UserDataModel extends UserData {
  UserDataModel({
    required String id,
    required String name,
    required String email,
    required String photoUrl,
    required String location,
    required String fcmToken,
    required Timestamp createdAt,
  }) : super(
          id: id,
          name: name,
          email: email,
          photoUrl: photoUrl,
          location: location,
          fcmToken: fcmToken,
          createdAt: createdAt,
        );

  factory UserDataModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return UserDataModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      location: data['location'],
      fcmToken: data['fcmToken'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "photoUrl": photoUrl,
      "location": location,
      "fcmToken": fcmToken,
      "createdAt": createdAt,
    };
  }
}
