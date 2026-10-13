// Service chỉ mô phỏng backend, không gọi API thật.
class MockAuthService {
  Future<String> login(String email, String password) async {
    // Giả lập thời gian gửi yêu cầu và nhận phản hồi từ server.
    await Future<void>.delayed(const Duration(seconds: 2));

    if (email == 'student@example.com' && password == '123456') {
      return 'mock_token_lab10_1';
    }

    throw const AuthException('Email hoặc mật khẩu không đúng.');
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}
