import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  // Có thể truyền client giả vào khi kiểm thử, app mặc định dùng HTTP thật.
  AuthService({this.client});

  final http.Client? client;

  Future<String> login(String username, String password) async {
    final requestClient = client ?? http.Client();
    try {
      // jsonEncode chuyển Map Dart thành chuỗi JSON gửi lên backend.
      final response = await requestClient
          .post(
            Uri.parse('https://dummyjson.com/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
              'expiresInMins': 30,
            }),
          )
          .timeout(const Duration(seconds: 15));

      // Kiểm tra HTTP status trước khi đọc dữ liệu thành công.
      if (response.statusCode == 400 || response.statusCode == 401) {
        throw const AuthException('Tên đăng nhập hoặc mật khẩu không đúng.');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AuthException(
          'Máy chủ trả về lỗi ${response.statusCode}. Vui lòng thử lại sau.',
        );
      }

      // jsonDecode chuyển JSON từ server về đối tượng Dart.
      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Response must be a JSON object');
      }
      final token = data['accessToken'];
      if (token is! String || token.trim().isEmpty) {
        throw const FormatException('Missing accessToken');
      }
      return token;
    } on TimeoutException {
      throw const AuthException('Kết nối quá lâu. Vui lòng thử lại.');
    } on http.ClientException {
      throw const AuthException(
        'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.',
      );
    } on FormatException {
      throw const AuthException('Phản hồi từ máy chủ không hợp lệ.');
    } finally {
      // Chỉ đóng client do service tự tạo; client truyền vào do bên gọi quản lý.
      if (client == null) requestClient.close();
    }
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}
