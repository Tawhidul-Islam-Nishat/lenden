import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- Helper to convert FirebaseAuthException to error message ---
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak (min 6 chars).';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // --- Register with email/password ---
  Future<(User?, String?)> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return (result.user, null); // Success: (user, null error)
    } on FirebaseAuthException catch (e) {
      return (null, _getAuthErrorMessage(e)); // Fail: (null, error)
    } catch (e) {
      return (null, 'Registration failed. Try again.'); // Generic error
    }
  }

  // --- Login with email/password ---
  Future<(User?, String?)> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return (result.user, null); // Success
    } on FirebaseAuthException catch (e) {
      return (null, _getAuthErrorMessage(e)); // Fail
    } catch (e) {
      return (null, 'Login failed. Try again.'); // Generic error
    }
  }

  // --- Logout ---
  Future<void> logout() async {
    await _auth.signOut();
  }

  // --- Stream of auth state changes ---
  Stream<User?> get userChanges => _auth.authStateChanges();

  // --- Get current user (nullable) ---
  User? get currentUser => _auth.currentUser;
}