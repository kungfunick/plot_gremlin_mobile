import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Internal state management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() => _setError(null);

  // -------------------------
  // Email / Password Methods
  // -------------------------

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // -------------------------
  // Google Sign-In
  // -------------------------
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      // Initialize GoogleSignIn
      await GoogleSignIn.instance.initialize(
        serverClientId: 'YOUR_WEB_CLIENT_ID', // only pass the ID
        // **do not** pass scopes here for v7.x
      );

      // Authenticate (sign-in)
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
      if (googleUser == null) {
        // user cancelled or failed
        return false;
      }

      // Get the authentication object (basic, without access token)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        _setError('Missing Google ID token');
        return false;
      }

      // **Request authorization for scopes to get the access token**
      final List<String> scopes = ['email']; // or any scopes you need
      final GoogleSignInClientAuthorization auth =
        await googleUser.authorizationClient.authorizeScopes(scopes);
      final String? accessToken = auth.accessToken;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      _setError('Google sign-in failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }


  // -------------------------
  // Apple Sign-In
  // -------------------------

  Future<bool> signInWithApple() async {
    try {
      _setLoading(true);
      _setError(null);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await _auth.signInWithCredential(oauthCredential);
      return true;
    } catch (e) {
      _setError('Apple sign-in failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // -------------------------
  // Sign Out
  // -------------------------

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
      await _auth.signOut();
    } catch (e) {
      _setError('Sign out failed: $e');
    }
  }

  // -------------------------
  // Helper: FirebaseAuth error messages
  // -------------------------

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
