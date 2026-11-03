// lib/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlife_alert_app/config/routes.dart';
import 'package:wildlife_alert_app/services/auth_service.dart';
import 'package:wildlife_alert_app/utils/validators.dart';
import 'package:wildlife_alert_app/widgets/loading_widget.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _locationController = TextEditingController();
  String _selectedLocation = '';
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;
  String _errorMessage = '';
  
  // List of available locations/zones
  final List<String> _locations = ['Zone-A', 'Zone-B', 'Zone-C', 'Zone-D'];
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    // _locationController.dispose();
    
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  
  // Handle signup
  Future<void> _signup() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    FocusScope.of(context).unfocus();  // ✅ fixes web pointer bug
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    
    try {
      // Get auth service
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // Sign up
      await authService.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        // location: _locationController.text.trim(),
        location: _selectedLocation,
      );

      // Delay before navigating to avoid focus error on Flutter Web
      await Future.delayed(Duration(milliseconds: 100));
      
      // Navigate to home screen
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign up: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? LoadingWidget()
            : Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App icon
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                        
                        SizedBox(height: 24),
                        
                        // App name
                        Text(
                          'Wildlife Alert',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        SizedBox(height: 36),
                        
                        // Name field
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: Validators.validateName,
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Email field
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Phone field
                        TextFormField(
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: Validators.validatePhoneNumber,
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Location dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedLocation.isEmpty ? null : _selectedLocation,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          items: _locations.map((location) {
                            return DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLocation = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a location';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: Validators.validatePassword,
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Error message
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        
                        // Signup button
                        ElevatedButton(
                          onPressed: _signup,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                              },
                              child: Text('Login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}