// lib/config/routes.dart
import 'package:flutter/material.dart';
import 'package:wildlife_alert_app/screens/auth/login_screen.dart';
import 'package:wildlife_alert_app/screens/auth/signup_screen.dart';
import 'package:wildlife_alert_app/screens/home/home_screen.dart';
import 'package:wildlife_alert_app/screens/splash_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  
  // Route map
  static Map<String, Widget Function(BuildContext)> get routes => {
    splash: (context) => SplashScreen(),
    login: (context) => LoginScreen(),
    signup: (context) => SignupScreen(),
    home: (context) => HomeScreen(),
  };
}
