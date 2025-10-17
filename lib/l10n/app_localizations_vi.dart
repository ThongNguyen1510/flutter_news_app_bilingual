// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Tin nhanh Việt';

  @override
  String get homeTitle => 'Tin nổi bật';

  @override
  String get categories => 'Chuyên mục';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get changeLanguage => 'Đổi ngôn ngữ';

  @override
  String get tabVietnam => 'Tin Việt';

  @override
  String get tabInternational => 'Tin Quốc tế';

  @override
  String get seeDetails => 'Đọc chi tiết';

  @override
  String publishedAt(String date) {
    return 'Đăng ngày $date';
  }

  @override
  String get newsListError => 'Không tải được danh sách tin.';

  @override
  String get emptyState => 'Hiện chưa có bài viết nào.';

  @override
  String get retry => 'Thử lại';

  @override
  String lastUpdated(String time) {
    return 'Cập nhật lần cuối $time';
  }

  @override
  String get searchHint => 'Tìm kiếm tin tức...';

  @override
  String get category_all => 'Tất cả';

  @override
  String get category_business => 'Kinh doanh';

  @override
  String get category_culture => 'Văn hóa';

  @override
  String get category_science => 'Khoa học';

  @override
  String get category_sports => 'Thể thao';

  @override
  String get category_technology => 'Công nghệ';
}
