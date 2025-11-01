import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/news_article.dart';
import '../models/saved_article.dart';
import 'auth_controller.dart';

const _kFavoritesKey = 'favorites';
const _kHistoryKey = 'history';
const _kHistoryLimit = 50;

/// Maintains user-local favorites and reading history.
/// Ghi chú (VI): Theo dõi bài viết yêu thích và lịch sử đọc cho từng người dùng
/// (theo UID). Dữ liệu được lưu cục bộ bằng SharedPreferences.
class ArticleTracker extends ChangeNotifier {
  ArticleTracker({required AuthController authController})
    : _authController = authController {
    _authListener = _handleAuthChanged; // Lắng nghe thay đổi đăng nhập
    _authController.addListener(_authListener!);
    _handleAuthChanged();
  }

  final AuthController _authController;
  final List<SavedArticle> _favorites = []; // Danh sách yêu thích
  final List<SavedArticle> _history = []; // Lịch sử đọc
  final Set<String> _favoriteIds = <String>{}; // Tập ID để check nhanh
  String? _currentUserId;
  VoidCallback? _authListener;
  Future<void>? _pendingLoad;

  List<SavedArticle> get favorites => List.unmodifiable(_favorites);
  List<SavedArticle> get history => List.unmodifiable(_history);
  bool get hasSignedInUser => _currentUserId != null;

  bool isFavorite(String articleId) => _favoriteIds.contains(articleId);

  // Thêm/bỏ yêu thích; tự động lưu lại
  Future<void> toggleFavorite(NewsArticle article) async {
    await _ensureLoaded();
    if (_currentUserId == null) return;
    final idx = _favorites.indexWhere((item) => item.id == article.id);
    if (idx >= 0) {
      _favorites.removeAt(idx);
      _favoriteIds.remove(article.id);
    } else {
      final saved = SavedArticle.fromArticle(article);
      _favorites.insert(0, saved);
      _favoriteIds.add(article.id);
    }
    await _persist(_kFavoritesKey, _favorites);
    notifyListeners();
  }

  // Thêm vào lịch sử đọc (giới hạn số lượng), tự động lưu lại
  Future<void> addToHistory(NewsArticle article) async {
    await _ensureLoaded();
    if (_currentUserId == null) return;
    final saved = SavedArticle.fromArticle(article);
    _history.removeWhere((item) => item.id == saved.id);
    _history.insert(0, saved);
    if (_history.length > _kHistoryLimit) {
      _history.removeRange(_kHistoryLimit, _history.length);
    }
    await _persist(_kHistoryKey, _history);
    notifyListeners();
  }

  // Xóa toàn bộ lịch sử đọc cho user hiện tại
  Future<void> clearHistory() async {
    await _ensureLoaded();
    if (_currentUserId == null) return;
    _history.clear();
    await _persist(_kHistoryKey, _history);
    notifyListeners();
  }

  // Khi trạng thái đăng nhập thay đổi: reset dữ liệu và tải lại theo UID mới
  void _handleAuthChanged() {
    final newUserId = _authController.user?.uid;
    if (newUserId == _currentUserId) {
      return;
    }
    _currentUserId = newUserId;
    _favorites.clear();
    _favoriteIds.clear();
    _history.clear();
    _pendingLoad = null;
    notifyListeners();
    if (newUserId != null) {
      _pendingLoad = _loadForUser(newUserId);
    }
  }

  // Đảm bảo dữ liệu đã được load cho UID hiện tại (lazy-load 1 lần)
  Future<void> _ensureLoaded() async {
    final uid = _currentUserId;
    if (uid == null) {
      return;
    }
    final pending = _pendingLoad ??= _loadForUser(uid);
    await pending;
  }

  // Tải favorites/history từ SharedPreferences theo UID
  Future<void> _loadForUser(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesRaw =
          prefs.getStringList(_storageKey(userId, _kFavoritesKey)) ?? [];
      final historyRaw =
          prefs.getStringList(_storageKey(userId, _kHistoryKey)) ?? [];
      if (_currentUserId != userId) {
        return;
      }
      _favorites
        ..clear()
        ..addAll(favoritesRaw.map(SavedArticle.decode));
      _favoriteIds
        ..clear()
        ..addAll(_favorites.map((item) => item.id));
      _history
        ..clear()
        ..addAll(historyRaw.map(SavedArticle.decode));
      notifyListeners();
    } finally {
      if (_currentUserId == userId) {
        _pendingLoad = null;
      }
    }
  }

  // Lưu danh sách vào SharedPreferences (theo khóa riêng của từng UID)
  Future<void> _persist(String key, List<SavedArticle> items) async {
    final uid = _currentUserId;
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey(uid, key),
      items.map((item) => item.encode()).toList(growable: false),
    );
  }

  String _storageKey(String userId, String key) => '$userId::$key';

  @override
  void dispose() {
    if (_authListener != null) {
      _authController.removeListener(_authListener!);
    }
    super.dispose();
  }
}
