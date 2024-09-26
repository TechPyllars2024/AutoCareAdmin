import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:autocareadmin/Authentication/service/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Dashboard/screens/admin_verify_shop.dart';
import '../widgets/alertMessage.dart';

class AdminLogin extends StatefulWidget {
  final double buttonWidth;
  final double buttonHeight;
  final Color buttonColor;

  const AdminLogin({
    this.buttonWidth = 200.0,
    this.buttonHeight = 50.0,
    this.buttonColor = Colors.orange,
  });

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authenticationService = AuthenticationService();

  bool _obscureText = true;

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AlertMessage(
            message: 'Logged in as: ${userCredential.user?.email}',
            backgroundColor: Colors.green,
            icon: Icons.check_circle,
            title: 'Success',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(milliseconds: 3000),
          width: 400.0,
        ),
      );

      // Navigate to verify shops page after login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminVerifyShop()),
      );

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AlertMessage(
            message: _errorMessage,
            backgroundColor: Colors.red,
            icon: Icons.error,
            title: 'Error',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(milliseconds: 3000),
          width: 800.0,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          // Centered white box
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 450.0, // Adjust the width as needed
              height: 350.0, // Adjust the height as needed
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Auto',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Care',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
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

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: AlertMessage(
                                    message: _errorMessage,
                                    backgroundColor: Colors.red,
                                    icon: Icons.error,
                                    title: 'Error',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  duration: const Duration(milliseconds: 3000),
                                  width: 400,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
                            backgroundColor: widget.buttonColor,
                          ),
                          child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}