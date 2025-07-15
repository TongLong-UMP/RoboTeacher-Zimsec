import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mock user for local development
  Map<String, dynamic>? _currentUser;

  // Get current user
  Map<String, dynamic>? get currentUser => _currentUser;

  bool get isLoggedIn => true; // or your logic for login

  Future<Map<String, dynamic>?> signUp(
      String email, String password, String role, String schoolId) async {
    try {
      // Simulate user creation
      _currentUser = {
        'uid': 'local_user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'role': role,
        'schoolId': schoolId,
        'avatar': 'default_cartoon.png',
        'createdAt': DateTime.now().toIso8601String(),
      };
      print('User signed up: $_currentUser');
      return _currentUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      // Simulate user login
      _currentUser = {
        'uid': 'local_user_123',
        'email': email,
        'role': 'student',
        'schoolId': 'SCHOOL123',
        'avatar': 'default_cartoon.png',
        'createdAt': DateTime.now().toIso8601String(),
      };
      print('User signed in: $_currentUser');
      return _currentUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    print('User signed out');
  }

  // Stream of auth changes (simplified for local development)
  Stream<Map<String, dynamic>?> get authStateChanges {
    return Stream.value(_currentUser);
  }
}
