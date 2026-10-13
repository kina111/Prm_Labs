import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/session_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.authService,
    required this.sessionService,
  });

  final AuthService authService;
  final SessionService sessionService;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Chạy một lần khi màn hình được tạo, không gọi lại trong build().
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    setState(() => _errorMessage = null);
    try {
      final token = await widget.sessionService.readToken();
      if (!mounted) return;

      // Trong phạm vi lab: chỉ kiểm tra token tồn tại, chưa kiểm tra hết hạn.
      final Widget nextScreen = token == null
          ? LoginScreen(
              authService: widget.authService,
              sessionService: widget.sessionService,
            )
          : HomeScreen(
              token: token,
              authService: widget.authService,
              sessionService: widget.sessionService,
            );
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute<void>(builder: (_) => nextScreen));
    } catch (_) {
      if (!mounted) return;
      setState(
        () =>
            _errorMessage = 'Không thể đọc phiên đăng nhập. Vui lòng thử lại.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_errorMessage == null) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Đang kiểm tra phiên đăng nhập...'),
              ] else ...[
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _restoreSession,
                  child: const Text('Thử lại'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
