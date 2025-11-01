import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles Firebase authentication state and exposes basic sign-in/out actions.
/// Ghi chú (VI): Quản lý trạng thái đăng nhập Firebase và cung cấp
/// các hàm đăng nhập/đăng ký/đăng xuất cơ bản cho UI.
class AuthController extends ChangeNotifier {
  AuthController({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    // Lấy người dùng hiện tại (nếu có) khi khởi tạo
    _user = _auth.currentUser;
    // Lắng nghe thay đổi trạng thái đăng nhập và thông báo cho UI
    _subscription = _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final FirebaseAuth _auth;
  StreamSubscription<User?>? _subscription;

  User? _user; // Người dùng hiện tại (null nếu chưa đăng nhập)
  bool _isBusy = false; // Cờ trạng thái đang xử lý (để khóa UI/hiển thị loading)
  String? _errorCode; // Mã lỗi chuẩn hóa để map sang i18n (AppLocalizations)

  User? get user => _user;
  bool get isBusy => _isBusy;
  String? get errorCode => _errorCode;

  // Đăng nhập bằng email/password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _execute(() async {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    });
  }

  // Đăng ký tài khoản bằng email/password
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

  // Đăng xuất người dùng hiện tại
  Future<void> signOut() => _auth.signOut();

  // Đăng nhập bằng Google (web dùng popup, mobile dùng GoogleSignIn)
  Future<bool> signInWithGoogle() async {
    return _execute(() async {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        await _auth.signInWithPopup(provider);
      } else {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          throw FirebaseAuthException(code: 'user-cancelled');
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
      }
    });
  }

  // Cập nhật tên hiển thị cho người dùng hiện tại
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

  // Helper bao bọc thao tác async: tự set busy, xử lý lỗi FirebaseAuth,
  // và chuẩn hóa mã lỗi để UI hiển thị thông báo.
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

  // Xóa lỗi hiện tại (thường gọi khi user đóng dialog lỗi)
  void clearError() => _setError(null);

  // Chuyển đổi mã lỗi FirebaseAuth sang key i18n nội bộ
  String _mapError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
      case 'wrong-password':
        return 'invalidCredentials';
      case 'user-cancelled':
        return 'signInCancelled';
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

  // Cập nhật trạng thái busy và thông báo cho UI
  void _setBusy(bool value) {
    if (_isBusy == value) return;
    _isBusy = value;
    notifyListeners();
  }

  // Cập nhật mã lỗi và thông báo cho UI
  void _setError(String? code) {
    if (_errorCode == code) return;
    _errorCode = code;
    notifyListeners();
  }

  @override
  void dispose() {
    // Hủy đăng ký lắng nghe để tránh rò rỉ bộ nhớ
    _subscription?.cancel();
    super.dispose();
  }
}
