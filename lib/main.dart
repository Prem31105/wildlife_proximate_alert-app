import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlife_alert_app/config/routes.dart';
import 'package:wildlife_alert_app/config/theme.dart';
import 'package:wildlife_alert_app/screens/splash_screen.dart';
import 'package:wildlife_alert_app/services/auth_service.dart';
import 'package:wildlife_alert_app/services/notification_service.dart';

// Background message handler for FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // You can process the message here
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with web config if running on web
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD6xakcF8jsZIWA4BTe0VMChzqSGznZBsc",
        authDomain: "wildlife-alert-app.firebaseapp.com",
        projectId: "wildlife-alert-app",
        storageBucket: "wildlife-alert-app.appspot.com",
        messagingSenderId: "11894580718",
        appId: "1:11894580718:android:02df5cc8b263c362e9daff",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Set background message handler for FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize notification service
  await NotificationService().init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        Provider(
          create: (context) => NotificationService(),
        ),
      ],
      child: MaterialApp(
        title: 'Wildlife Alert App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,       
        initialRoute: AppRoutes.splash, 
      ),
    );
  }
}
