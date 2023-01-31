import '../../../domain/entities/google_user_entity.dart';

class GoogleUserModel extends GoogleUser {
  GoogleUserModel({
    required String accessToken,
    required String displayName,
    required String email,
    required String photoUrl,
  }) : super(
          accessToken: accessToken,
          displayName: displayName,
          email: email,
          photoUrl: photoUrl,
        );

  factory GoogleUserModel.fromJson(Map<String, dynamic> json) => GoogleUserModel(
        accessToken: json["accessToken"] as String,
        displayName: json["displayName"] as String,
        email: json["email"] as String,
        photoUrl: json["photoUrl"] as String,
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "displayName": displayName,
        "email": email,
        "photoUrl": photoUrl,
      };
}
