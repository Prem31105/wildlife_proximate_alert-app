// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wildlife_alert_app/utils/constants.dart';

class ApiService {
  // Base URL for backend API
  final String _baseUrl = Constants.apiBaseUrl;
  
  // API endpoints
  static const String _sendAlertEndpoint = '/send-alert';
  
  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };
  
  // Send test alert for development purposes
  Future<bool> sendTestAlert({
    required String animal,
    required String location,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$_sendAlertEndpoint');
      
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'animal': animal,
          'location': location,
          'time': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error sending test alert: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception in sendTestAlert: $e');
      return false;
    }
  }
}