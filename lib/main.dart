import 'package:autocareadmin/Authentication/screens/admin_login.dart';
import 'package:autocareadmin/Dashboard/screens/example.dart';
// import 'package:autocareadmin/Authentication/screens/login_sample.dart';
import 'package:autocareadmin/Dashboard/screens/verifushop2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBXEcv6WxwIXp7KyEkI9Xpqkovj3LoGz1U",
      projectId: "autocare-63060",
      messagingSenderId: "1000331742478",
      appId: "1:1000331742478:web:10267f670bbbebb379db5f",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoCare Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AdminVerifyShop2(),
    );
  }
}
