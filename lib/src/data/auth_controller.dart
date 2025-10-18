import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Handles Firebase authentication state and exposes basic sign-in/out actions.
class AuthController extends ChangeNotifier {
  AuthController({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    _user = _auth.currentUser;
    _subscription = _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final FirebaseAuth _auth;
  StreamSubscription<User?>? _subscription;

  User? _user;
  bool _isBusy = false;
  String? _errorCode;

  User? get user => _user;
  bool get isBusy => _isBusy;
  String? get errorCode => _errorCode;

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _execute(() async {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    });
  }

  Future<bool> registerWithEmail({
    required String email,
    required String password,
  }) async {
    return _execute(() async {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signOut() => _auth.signOut();

  Future<bool> updateDisplayName(String displayName) async {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) {
      _setError('profileInvalidDisplayName');
      return false;
    }
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      _setError('profileSignInRequired');
      return false;
    }
    final success = await _execute(() async {
      await currentUser.updateDisplayName(trimmed);
      await currentUser.reload();
      _user = _auth.currentUser;
    });
    if (success) {
      _user = _auth.currentUser;
      notifyListeners();
    }
    return success;
  }

  Future<bool> _execute(Future<void> Function() runner) async {
    _setBusy(true);
    try {
      await runner();
      _setError(null);
      return true;
    } on FirebaseAuthException catch (error) {
      _setError(_mapError(error));
      return false;
    } finally {
      _setBusy(false);
    }
  }

  void clearError() => _setError(null);

  String _mapError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
      case 'wrong-password':
        return 'invalidCredentials';
      case 'email-already-in-use':
        return 'emailInUse';
      case 'weak-password':
        return 'weakPassword';
      case 'invalid-email':
        return 'invalidEmail';
      case 'operation-not-allowed':
        return 'operationNotAllowed';
      case 'too-many-requests':
        return 'tooManyRequests';
      case 'requires-recent-login':
        return 'profileRequiresRecentLogin';
      case 'invalid-display-name':
        return 'profileInvalidDisplayName';
      default:
        return 'unknownError';
    }
  }

  void _setBusy(bool value) {
    if (_isBusy == value) return;
    _isBusy = value;
    notifyListeners();
  }

  void _setError(String? code) {
    if (_errorCode == code) return;
    _errorCode = code;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
