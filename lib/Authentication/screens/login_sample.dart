// lib/Authentication/screens/login_sample.dart
import 'package:autocareadmin/Authentication/service/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authenticationService = AuthenticationService();

  bool _isLoading = false;
  String _errorMessage = '';

  // Function to log in with username and password
  Future<void> loginWithUsernameAndPassword(String username, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      UserCredential userCredential = await _authenticationService.loginWithUsernameAndPassword(username, password);

      // Successfully logged in
      print('Logged in as: ${userCredential.user?.email}');

      // Navigate to admin dashboard or home screen after login
      // Navigator.pushReplacementNamed(context, '/adminDashboard');

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
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
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                String username = _usernameController.text.trim();
                String password = _passwordController.text.trim();
                if (username.isNotEmpty && password.isNotEmpty) {
                  loginWithUsernameAndPassword(username, password);
                } else {
                  setState(() {
                    _errorMessage = 'Please enter both username and password';
                  });
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}