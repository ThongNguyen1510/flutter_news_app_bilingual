import 'package:flutter/material.dart';

import '../models/news_article.dart';
import 'news_repository.dart';
import 'news_source.dart';

/// Controls fetching, filtering, and exposing the news feed state.
/// Ghi chú (VI): Quản lý danh sách bài viết (lấy dữ liệu, lọc theo danh mục
/// và tìm kiếm), đồng thời thông báo cho UI khi trạng thái thay đổi.
class NewsController extends ChangeNotifier {
  NewsController(this._repository);

  final NewsRepository _repository;

  List<NewsArticle> _articles = const []; // Danh sách bài viết hiện tại
  bool _isLoading = false; // Cờ đang tải dữ liệu
  String? _errorMessage; // Lỗi (nếu có) để UI hiển thị
  DateTime? _lastUpdated; // Thời gian cập nhật gần nhất
  String _selectedCategory = 'all'; // Danh mục đang chọn
  String _searchTerm = ''; // Từ khóa tìm kiếm
  Locale _locale = const Locale('vi'); // Ngôn ngữ hiển thị
  NewsSource _source = NewsSource.vietnam; // Nguồn tin: VN (RSS) hoặc quốc tế

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;
  String get selectedCategory => _selectedCategory;
  String get searchTerm => _searchTerm;
  Locale get locale => _locale;
  NewsSource get source => _source;

  // Tải danh sách bài viết từ Repository. Có thể ép làm mới (bỏ cache)
  Future<void> loadArticles({bool forceRefresh = false}) async {
    if (_isLoading && !forceRefresh) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await _repository.fetchArticles(
        locale: _locale,
        source: _source,
        category: _selectedCategory,
        keyword: _searchTerm,
        forceRefresh: forceRefresh,
      );
      _articles = fetched;
      _lastUpdated = DateTime.now();
    } catch (error) {
      _errorMessage = error.toString();
      _articles = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cập nhật danh mục và tự động tải lại
  void updateCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadArticles(forceRefresh: true);
  }

  // Cập nhật từ khóa tìm kiếm và tự động tải lại
  void updateSearchTerm(String term) {
    final trimmed = term.trim();
    if (_searchTerm == trimmed) return;
    _searchTerm = trimmed;
    loadArticles(forceRefresh: true);
  }

  // Cập nhật ngôn ngữ hiển thị và tự động tải lại
  void updateLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    loadArticles(forceRefresh: true);
  }

  // Cập nhật nguồn tin và locale; reset filter khi đổi nguồn
  void updateSource(NewsSource source, Locale locale) {
    bool shouldReload = _source != source || _locale != locale;
    if (_selectedCategory != 'all') {
      _selectedCategory = 'all';
      shouldReload = true;
    }
    if (_searchTerm.isNotEmpty) {
      _searchTerm = '';
      shouldReload = true;
    }
    _source = source;
    _locale = locale;
    if (shouldReload) {
      loadArticles(forceRefresh: true);
    } else {
      notifyListeners();
    }
  }
}
