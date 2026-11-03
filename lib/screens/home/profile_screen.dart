// lib/screens/home/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlife_alert_app/models/user_model.dart';
import 'package:wildlife_alert_app/services/auth_service.dart';
import 'package:wildlife_alert_app/utils/helpers.dart';
import 'package:wildlife_alert_app/widgets/loading_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  UserModel? _user;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  // Load user data
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // Get auth service
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // Get current user data
      _user = await authService.getCurrentUserData();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingWidget();
    }
    
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserData,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_user == null) {
      return Center(
        child: Text('No user data found'),
      );
    }
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    _user!.name.isNotEmpty ? _user!.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                SizedBox(height: 16),
                
                // User name
                Text(
                  _user!.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 8),
                
                // User location
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _user!.location,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 32),
          
          // Profile details
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Email
                  _buildInfoRow(
                    icon: Icons.email,
                    title: 'Email',
                    value: _user!.email,
                  ),
                  
                  Divider(height: 24),
                  
                  // Phone
                  _buildInfoRow(
                    icon: Icons.phone,
                    title: 'Phone',
                    value: Helpers.formatPhoneNumber(_user!.phoneNumber),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // App info
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Location
                  _buildInfoRow(
                    icon: Icons.location_on,
                    title: 'Alert Zone',
                    value: _user!.location,
                  ),
                  
                  Divider(height: 24),
                  
                  // FCM Token
                  _buildInfoRow(
                    icon: Icons.notifications,
                    title: 'Notification Status',
                    value: _user!.fcmToken.isNotEmpty ? 'Enabled' : 'Disabled',
                    valueColor: _user!.fcmToken.isNotEmpty
                        ? Colors.green
                        : Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Build info row widget
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey,
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}