import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/session_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.authService, this.sessionService});

  // Các tham số tùy chọn giúp kiểm thử; app mặc định dùng service thật.
  final AuthService? authService;
  final SessionService? sessionService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.3 - Auto Login & Logout',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: SplashScreen(
        authService: authService ?? AuthService(),
        sessionService: sessionService ?? SessionService(),
      ),
    );
  }
}
