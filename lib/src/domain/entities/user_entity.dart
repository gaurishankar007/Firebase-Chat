import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String location;
  final String fcmToken;
  final Timestamp createdAt;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.location,
    required this.fcmToken,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        name,
        email,
        photoUrl,
        location,
        fcmToken,
        createdAt,
      ];
}
