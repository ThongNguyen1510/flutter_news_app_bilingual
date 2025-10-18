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
  String get category_culture => 'Văn hoá';

  @override
  String get category_science => 'Khoa học';

  @override
  String get category_sports => 'Thể thao';

  @override
  String get category_technology => 'Công nghệ';

  @override
  String get authPanelTitle => 'Tài khoản';

  @override
  String get authPanelGuest => 'Bạn đang đọc ở chế độ khách';

  @override
  String get authPanelPrompt => 'Đăng nhập để đồng bộ trải nghiệm.';

  @override
  String authPanelGreeting(String name) {
    return 'Xin chào $name';
  }

  @override
  String get authSignIn => 'Đăng nhập';

  @override
  String get authRegister => 'Đăng ký';

  @override
  String get authSignOut => 'Đăng xuất';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Mật khẩu';

  @override
  String get authConfirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get authCancel => 'Hủy';

  @override
  String get authDialogSignInTitle => 'Đăng nhập';

  @override
  String get authDialogRegisterTitle => 'Tạo tài khoản';

  @override
  String get authErrorInvalidCredentials => 'Email hoặc mật khẩu không đúng.';

  @override
  String get authErrorEmailInUse => 'Email này đã được sử dụng.';

  @override
  String get authErrorWeakPassword => 'Mật khẩu cần ít nhất 6 ký tự.';

  @override
  String get authErrorPasswordMismatch => 'Mật khẩu xác nhận không khớp.';

  @override
  String get authErrorInvalidEmail => 'Email không đúng định dạng.';

  @override
  String get authErrorOperationNotAllowed =>
      'Dịch vụ đăng nhập email/mật khẩu chưa được bật.';

  @override
  String get authErrorTooManyRequests =>
      'Thử quá nhiều lần. Vui lòng thử lại sau.';

  @override
  String get authErrorUnknown => 'Có lỗi xảy ra, vui lòng thử lại.';

  @override
  String get menuFavorites => 'Bài viết yêu thích';

  @override
  String get menuHistory => 'Lịch sử đọc';

  @override
  String get favoritesLoginRequired =>
      'Vui lòng đăng nhập để xem danh sách yêu thích của bạn.';

  @override
  String get favoritesTitle => 'Bài viết yêu thích';

  @override
  String get favoritesEmpty => 'Bạn chưa lưu bài viết nào.';

  @override
  String get favoritesSaveTooltip => 'Lưu vào yêu thích';

  @override
  String get favoritesRemoveTooltip => 'Bỏ khỏi yêu thích';

  @override
  String get historyTitle => 'Lịch sử đọc';

  @override
  String get historyEmpty => 'Bạn chưa đọc bài viết nào.';

  @override
  String get historyClear => 'Xóa lịch sử';

  @override
  String get historyClearConfirm =>
      'Thao tác này sẽ xóa toàn bộ lịch sử đọc của bạn.';

  @override
  String get historyLoginRequired =>
      'Vui lòng đăng nhập để xem lịch sử đọc của bạn.';

  @override
  String get accountPageTitle => 'Tài khoản & cài đặt';

  @override
  String get accountOverviewTitle => 'Tài khoản';

  @override
  String get accountSignInDescription =>
      'Đăng nhập để quản lý tài khoản và nội dung đã lưu.';

  @override
  String get accountProfileButton => 'Xem hồ sơ';

  @override
  String get accountAppearanceTitle => 'Giao diện';

  @override
  String get themeModeLabel => 'Chế độ hiển thị';

  @override
  String get themeModeSystem => 'Theo hệ thống';

  @override
  String get themeModeLight => 'Chế độ sáng';

  @override
  String get themeModeDark => 'Chế độ tối';

  @override
  String get textSizeLabel => 'Kích cỡ chữ';

  @override
  String get textSizeSmall => 'Nhỏ hơn';

  @override
  String get textSizeLarge => 'Lớn hơn';

  @override
  String accountItemsCount(int count) {
    return '$count mục';
  }

  @override
  String get profilePageTitle => 'Hồ sơ người dùng';

  @override
  String get profileDisplayNameLabel => 'Tên hiển thị';

  @override
  String get profileDisplayNameHint => 'Tên sẽ xuất hiện trong ứng dụng';

  @override
  String get profileUpdateButton => 'Lưu thay đổi';

  @override
  String get profileResetButton => 'Đặt lại';

  @override
  String get profileUpdateSuccess => 'Cập nhật hồ sơ thành công.';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileUidLabel => 'Mã người dùng';

  @override
  String get profileVerifiedLabel => 'Xác thực email';

  @override
  String get profileVerifiedYes => 'Đã xác thực';

  @override
  String get profileVerifiedNo => 'Chưa xác thực';

  @override
  String get profileCreationLabel => 'Tạo ngày';

  @override
  String get profileLastSignInLabel => 'Đăng nhập gần nhất';

  @override
  String get profileErrorInvalidDisplayName =>
      'Tên hiển thị không được để trống.';

  @override
  String get profileErrorRequiresRecentLogin =>
      'Vui lòng đăng nhập lại để tiếp tục.';

  @override
  String get profileErrorUpdateFailed =>
      'Không thể cập nhật hồ sơ. Vui lòng thử lại.';

  @override
  String get profileSignInRequired => 'Vui lòng đăng nhập để xem hồ sơ.';
}
