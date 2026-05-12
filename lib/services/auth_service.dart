import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  String _friendlyError(String? code) {
    switch (code) {
      case 'user-not-found':
        return 'NO ACCOUNT WITH THAT EMAIL →';
      case 'wrong-password':
        return 'WRONG PASSWORD →';
      case 'email-already-in-use':
        return 'ACCOUNT ALREADY EXISTS →';
      case 'invalid-email':
        return 'INVALID EMAIL FORMAT →';
      default:
        return 'SOMETHING WENT WRONG →';
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _friendlyError(e.code);
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _friendlyError(e.code);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
