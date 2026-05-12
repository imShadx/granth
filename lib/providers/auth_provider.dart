import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GranthAuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}