import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'profile_view.dart';
import '../services/notification_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.authService,
    this.notificationService,
  });

  final AuthService authService;
  final NotificationService? notificationService;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final Stream<User?> _authStream;
  late final _notifications =
      widget.notificationService ?? NotificationService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Giữ một stream ổn định, không tạo lại mỗi lần build.
    _authStream = widget.authService.authStateChanges();
  }

  Future<void> _signIn() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await widget.authService.signInWithGoogle();
      if (!mounted) return;
      // Chỉ gửi sau khi cả Google và Firebase xác thực thành công.
      // Không đặt trong build/stream để tránh gửi lại khi khôi phục phiên.
      try {
        final allowed = await _notifications.showLoginSuccessNotification();
        if (!mounted) return;
        if (!allowed) {
          setState(
            () => _errorMessage = 'Đăng nhập thành công. Chưa có quyền thông báo; bạn có thể bật trong Cài đặt ứng dụng.',
          );
        }
      } catch (_) {
        // Lỗi thông báo không được biến thành lỗi đăng nhập.
        if (!mounted) return;
        setState(
          () => _errorMessage =
              'Đăng nhập thành công nhưng chưa thể hiển thị thông báo.',
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = authErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await widget.authService.signOut();
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _errorMessage = 'Chưa thể hoàn tất đăng xuất. Vui lòng thử lại.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Firebase tự lưu và khôi phục phiên. Không cần SharedPreferences của Lab 10.3.
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Không thể đọc phiên. Vui lòng mở lại ứng dụng.'),
            ),
          );
        }
        final user = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(user == null ? 'Google Sign-In' : 'Hồ sơ người dùng'),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (user == null)
                        const Text(
                          'Đăng nhập bằng tài khoản Google để tiếp tục.',
                        )
                      else
                        ProfileView(user: user),
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
                        onPressed: _isLoading
                            ? null
                            : (user == null ? _signIn : _signOut),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                user == null
                                    ? 'Đăng nhập với Google'
                                    : 'Đăng xuất',
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
