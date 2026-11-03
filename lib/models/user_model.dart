// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String location;
  final String phoneNumber;
  final String fcmToken;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.location,
    required this.phoneNumber,
    required this.fcmToken,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'location': location,
      'number': phoneNumber,
      'fcmToken': fcmToken,
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      phoneNumber: map['number'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
    );
  }
}
