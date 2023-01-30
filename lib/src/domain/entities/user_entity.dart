import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String location;
  final String fcmToken;
  final Timestamp createdAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.location,
    required this.fcmToken,
    required this.createdAt,
  });
}
