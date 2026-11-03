// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlife_alert_app/config/routes.dart';
import 'package:wildlife_alert_app/screens/home/help_screen.dart';
import 'package:wildlife_alert_app/screens/home/history_screen.dart';
import 'package:wildlife_alert_app/screens/home/profile_screen.dart';
import 'package:wildlife_alert_app/services/auth_service.dart';
import 'package:wildlife_alert_app/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // List of screen widgets
  final List<Widget> _screens = [
    HistoryScreen(),
    ProfileScreen(),
    HelpScreen(),
  ];
  
  // List of app bar titles
  final List<String> _titles = [
    'Detection History',
    'Profile',
    'Help Center',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          // Logout button
          if (_currentIndex == 1) // Show only on profile screen
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _showLogoutDialog();
              },
            ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
        ],
      ),
    );
  }
  
  // Show logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              // Get auth service and sign out
              final authService = Provider.of<AuthService>(context, listen: false);
              await authService.signOut();
              
              // Navigate to login screen
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}