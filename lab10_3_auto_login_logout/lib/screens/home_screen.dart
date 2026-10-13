import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/session_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.token,
    required this.authService,
    required this.sessionService,
  });

  final String token;
  final AuthService authService;
  final SessionService sessionService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggingOut = false;
  String? _errorMessage;

  Future<void> _logout() async {
    if (_isLoggingOut) return;
    setState(() {
      _isLoggingOut = true;
      _errorMessage = null;
    });
    try {
      // Phải xóa token trước, nếu không lần mở app sau vẫn tự đăng nhập.
      await widget.sessionService.clearSession();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => LoginScreen(
            authService: widget.authService,
            sessionService: widget.sessionService,
          ),
        ),
        (route) => false, // Xóa mọi route cũ, Back không thể trở về Home.
      );
    } catch (_) {
      if (!mounted) return;
      setState(
        () =>
            _errorMessage = 'Không thể xóa phiên. Vui lòng thử đăng xuất lại.',
      );
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = widget.token;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Bạn đã đăng nhập!'),
              const SizedBox(height: 12),
              const Text(
                'Phiên đã được lưu. Đóng và mở lại app để thử tự đăng nhập.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Access token: ${token.length > 24 ? '${token.substring(0, 24)}...' : token}',
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoggingOut ? null : _logout,
                child: _isLoggingOut
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Đăng xuất'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
