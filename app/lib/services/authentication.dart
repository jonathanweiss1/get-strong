import 'package:app/config.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  /// create user
  Future<GSUser?> signUpUser(
    String email,
    String password,
  ) async {
    if (DEBUG_SKIP_AUTH) return null;
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return GSUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
  } 

   ///signOutUser 
   Future<void> signOutUser() async {
    if (DEBUG_SKIP_AUTH) return;
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  /// signInUser
  Future<GSUser?> signInUser(
    String email,
    String password,
  ) async {
    if (DEBUG_SKIP_AUTH) return null;
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return GSUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
  } 

  GSUser? getCurrentUser () {
    if (DEBUG_SKIP_AUTH) return null;
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return null;
    } else {
      return GSUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
    }
  }
}
