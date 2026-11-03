// lib/screens/splash_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wildlife_alert_app/config/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserState();
  }
  
  // Check if user is already logged in
  void _checkUserState() async {
    await Future.delayed(Duration(seconds: 2));
    
    if (mounted) {
      // Check if user is already authenticated
      if (FirebaseAuth.instance.currentUser != null) {
        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else {
        // Navigate to login screen
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Icon(
              Icons.warning_amber_rounded,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            
            SizedBox(height: 20),
            
            // App name
            Text(
              'Wildlife Alert',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 40),
            
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}