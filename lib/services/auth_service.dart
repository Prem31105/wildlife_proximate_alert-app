// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wildlife_alert_app/models/user_model.dart';
import 'package:wildlife_alert_app/services/database_service.dart';
import 'package:wildlife_alert_app/services/notification_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();
  
  // Current user
  User? get currentUser => _auth.currentUser;
  
  // User stream
  Stream<User?> get userStream => _auth.authStateChanges();
  
  // Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String location,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Get FCM token
      String? fcmToken = await _notificationService.getFCMToken();
      
      // Create user model
      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        location: location,
        phoneNumber: phoneNumber,
        fcmToken: fcmToken ?? '',
      );
      
      // Save user data to Firestore
      await _databaseService.saveUserData(userModel);
      
      return userCredential;
    } catch (e) {
      print('Error in signUp: $e');
      rethrow;
    }
  }
  
  // Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update FCM token
      String? fcmToken = await _notificationService.getFCMToken();
      if (fcmToken != null) {
        await _databaseService.updateFCMToken(userCredential.user!.uid, fcmToken);
      }
      
      return userCredential;
    } catch (e) {
      print('Error in signIn: $e');
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      print('Error in signOut: $e');
      rethrow;
    }
  }
  
  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUser != null) {
        return await _databaseService.getUserData(currentUser!.uid);
      }
      return null;
    } catch (e) {
      print('Error in getCurrentUserData: $e');
      rethrow;
    }
  }
}