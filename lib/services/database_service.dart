// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wildlife_alert_app/models/alert_model.dart';
import 'package:wildlife_alert_app/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  final CollectionReference _usersCollection = 
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _alertsCollection = 
      FirebaseFirestore.instance.collection('alerts');
  
  // Save user data to Firestore
  Future<void> saveUserData(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error in saveUserData: $e');
      rethrow;
    }
  }
  
  // Update FCM token
  Future<void> updateFCMToken(String uid, String token) async {
    try {
      await _usersCollection.doc(uid).update({
        'fcmToken': token,
      });
    } catch (e) {
      print('Error in updateFCMToken: $e');
      rethrow;
    }
  }
  
  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error in getUserData: $e');
      rethrow;
    }
  }
  
  // Get alerts for a location
  Stream<List<AlertModel>> getAlerts(String location) {
    try {
      return _alertsCollection
          .where('location', isEqualTo: location)
          .orderBy('time', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return AlertModel.fromMap(data);
            }).toList();
          });
    } catch (e) {
      print('Error in getAlerts: $e');
      rethrow;
    }
  }
  
  // Get alerts for user's location
  Stream<List<AlertModel>> getAlertsForUser(String uid) async* {
    try {
      // Get user data
      UserModel? user = await getUserData(uid);
      if (user != null) {
        // Get alerts for user's location
        yield* getAlerts(user.location);
      } else {
        yield [];
      }
    } catch (e) {
      print('Error in getAlertsForUser: $e');
      rethrow;
    }
  }
}