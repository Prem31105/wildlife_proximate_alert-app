// lib/screens/home/history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlife_alert_app/models/alert_model.dart';
import 'package:wildlife_alert_app/services/auth_service.dart';
import 'package:wildlife_alert_app/services/database_service.dart';
import 'package:wildlife_alert_app/widgets/alert_card.dart';
import 'package:wildlife_alert_app/widgets/loading_widget.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin {
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = true;
  String _errorMessage = '';
  
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    // Get current user
    final authService = Provider.of<AuthService>(context);
    final currentUserId = authService.currentUser?.uid;
    
    if (currentUserId == null) {
      return Center(
        child: Text('You need to be logged in to view alerts'),
      );
    }
    
    return Scaffold(
      body: StreamBuilder<List<AlertModel>>(
        stream: _databaseService.getAlertsForUser(currentUserId),
        builder: (context, snapshot) {
          // Show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting && _isLoading) {
            return LoadingWidget();
          }
          
          // Update loading state
          if (_isLoading) {
            _isLoading = false;
          }
          
          // Show error message
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load alerts: ${snapshot.error}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          // Show empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No wildlife alerts yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You\'ll be notified when wildlife is detected in your area',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Group alerts by active and past
          final activeAlerts = snapshot.data!
              .where((alert) => alert.isActive)
              .toList();
          
          final pastAlerts = snapshot.data!
              .where((alert) => !alert.isActive)
              .toList();
          
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isLoading = true;
              });
              await Future.delayed(Duration(seconds: 1));
              setState(() {
                _isLoading = false;
              });
            },
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Active alerts section
                if (activeAlerts.isNotEmpty) ...[
                  Text(
                    'Active Alerts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...activeAlerts.map((alert) => Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: AlertCard(
                      alert: alert,
                      isActive: true,
                    ),
                  )),
                ],
                
                // Past alerts section
                if (pastAlerts.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text(
                    'Past Alerts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...pastAlerts.map((alert) => Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: AlertCard(
                      alert: alert,
                      isActive: false,
                    ),
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}