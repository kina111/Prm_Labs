import 'package:shared_preferences/shared_preferences.dart';

// Tách việc đọc/ghi token khỏi giao diện để dễ theo dõi luồng đăng nhập.
class SessionService {
  static const tokenKey = 'access_token';

  Future<String?> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    // Token rỗng được xem như chưa đăng nhập.
    return token == null || token.trim().isEmpty ? null : token;
  }

  Future<void> saveToken(String token) async {
    if (token.trim().isEmpty) {
      throw const SessionException('Token không hợp lệ.');
    }
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(tokenKey, token);
    if (!saved) {
      throw const SessionException('Không thể lưu phiên. Vui lòng thử lại.');
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    // Chỉ xóa token của app, không xóa các thiết lập không liên quan.
    final removed = await prefs.remove(tokenKey);
    if (!removed) {
      throw const SessionException('Không thể xóa phiên. Vui lòng thử lại.');
    }
  }
}

class SessionException implements Exception {
  const SessionException(this.message);
  final String message;
}
