// lib/Authentication/service/authentication_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> loginWithUsernameAndPassword(String username, String password) async {
    // Fetch the email associated with the username from Firestore
    QuerySnapshot querySnapshot = await _firestore
        .collection('admin_users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Invalid username');
    }

    // Retrieve the email
    String email = (querySnapshot.docs.first.data() as Map<String, dynamic>)['email'];

    // Log in using Firebase Authentication
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print('Logged in as: ${userCredential.user?.email}');
    return userCredential;
  }
}