import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isGoogleSignInInitialized = false;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
    _initializeGoogleSignIn();
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Initialize Google Sign In
  Future<void> _initializeGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      debugPrint('Google Sign-In initialization error: $e');
      _isGoogleSignInInitialized = false;
    }
  }

  // Email/Password Sign Up
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Email/Password Sign In
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Google Sign In (Updated for google_sign_in 7.2.0+)
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      // Ensure Google Sign-In is initialized
      if (!_isGoogleSignInInitialized) {
        await _initializeGoogleSignIn();
      }

      if (!_isGoogleSignInInitialized) {
        throw Exception('Google Sign-In could not be initialized');
      }

      // Check if platform supports authenticate
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        // Use authenticate for supported platforms
        await GoogleSignIn.instance.authenticate(scopeHint: ['email']);

        // Listen for authentication events
        final completer = Completer<GoogleSignInAccount?>();
        final subscription = GoogleSignIn.instance.authenticationEvents.listen(
          (event) {
            if (event is GoogleSignInAuthenticationEventSignIn) {
              completer.complete(event.user);
            } else if (event is GoogleSignInAuthenticationEventSignOut) {
              completer.complete(null);
            }
          },
        );

        final googleUser = await completer.future.timeout(
          const Duration(seconds: 30),
          onTimeout: () => null,
        );

        subscription.cancel();

        if (googleUser == null) {
          _setLoading(false);
          return false;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
        return true;
      } else {
        // Web or unsupported platform
        _setError('Google Sign-In not supported on this platform. Please use the web interface.');
        return false;
      }
    } catch (e) {
      _setError('Google sign-in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Apple Sign In
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
      _setError('Apple sign-in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Password Reset
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

  // Sign Out
  Future<void> signOut() async {
    try {
      // Sign out from Google if initialized
      if (_isGoogleSignInInitialized) {
        try {
          await GoogleSignIn.instance.signOut();
        } catch (e) {
          debugPrint('Google Sign-Out error: $e');
        }
      }
      await _auth.signOut();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    }
  }

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

  void clearError() {
    _setError(null);
  }
}