import 'package:get_strong/config.dart';
import 'package:get_strong/model/user.dart';
import 'package:get_strong/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/// Handles everything regarding auth.
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService database = Get.find<DatabaseService>();

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
        final user = GSUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? 'User',
        );
        final cloudUserCreated = await database.createUser(user);
        return cloudUserCreated ? user : null;
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

  /// Returns the currently logged in user
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
