import 'package:flutter/material.dart';

import '../models/news_article.dart';
import 'news_repository.dart';
import 'news_source.dart';

/// Controls fetching, filtering, and exposing the news feed state.
class NewsController extends ChangeNotifier {
  NewsController(this._repository);

  final NewsRepository _repository;

  List<NewsArticle> _articles = const [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastUpdated;
  String _selectedCategory = 'all';
  String _searchTerm = '';
  Locale _locale = const Locale('vi');
  NewsSource _source = NewsSource.vietnam;

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;
  String get selectedCategory => _selectedCategory;
  String get searchTerm => _searchTerm;
  Locale get locale => _locale;
  NewsSource get source => _source;

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

  void updateCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadArticles(forceRefresh: true);
  }

  void updateSearchTerm(String term) {
    final trimmed = term.trim();
    if (_searchTerm == trimmed) return;
    _searchTerm = trimmed;
    loadArticles(forceRefresh: true);
  }

  void updateLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    loadArticles(forceRefresh: true);
  }

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
