import 'package:flutter/material.dart';

import '../services/mock_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key giúp truy cập FormState để kiểm tra toàn bộ các trường.
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = MockAuthService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    // Chặn gửi nhiều yêu cầu trong lúc đang chờ backend.
    if (_isLoading) return;
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final token = await _authService.login(email, _passwordController.text);

      // Sau await, màn hình có thể đã bị đóng.
      if (!mounted) return;

      // Thay Login bằng Home để nút Back không quay lại Login.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => HomeScreen(email: email, token: token),
        ),
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại.');
    } finally {
      // Luôn tắt trạng thái chờ, kể cả khi xác thực thất bại.
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Vui lòng nhập email.';
                        if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                            .hasMatch(email)) {
                          return 'Email không đúng định dạng.';
                        }
                        return null; // null nghĩa là dữ liệu hợp lệ.
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      enabled: !_isLoading,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      decoration: const InputDecoration(
                        labelText: 'Mật khẩu',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu.';
                        }
                        if (value.length < 6) {
                          return 'Mật khẩu phải có ít nhất 6 ký tự.';
                        }
                        return null;
                      },
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Đăng nhập'),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Tài khoản thử nghiệm:\n'
                      'Email: student@example.com\n'
                      'Mật khẩu: 123456',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.email, required this.token});

  final String email;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Đăng nhập thành công!'),
              const SizedBox(height: 12),
              Text('Xin chào, $email'),
              const SizedBox(height: 12),
              // Hiển thị token giả để quan sát kết quả của service trong lab.
              Text('Mock token: $token'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
