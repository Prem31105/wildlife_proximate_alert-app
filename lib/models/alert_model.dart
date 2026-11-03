// lib/models/alert_model.dart
class AlertModel {
  final String id;
  final String animal;
  final String location;
  final DateTime time;
  final bool isActive;

  AlertModel({
    required this.id,
    required this.animal,
    required this.location,
    required this.time,
    this.isActive = true,
  });

  // Convert AlertModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'animal': animal,
      'location': location,
      'time': time.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Create AlertModel from Firestore document
  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'] ?? '',
      animal: map['animal'] ?? '',
      location: map['location'] ?? '',
      time: map['time'] != null 
          ? DateTime.parse(map['time']) 
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }
}