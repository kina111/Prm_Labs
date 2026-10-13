import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? setupError;
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    setupError = 'Bài lab này cấu hình cho Android. Vui lòng chạy trên máy Android hoặc Android Emulator.';
  } else {
    try {
      // Android đọc cấu hình do Google Services plugin tạo từ google-services.json.
      await Firebase.initializeApp();
    } catch (_) {
      setupError =
          'Chưa khởi tạo được Firebase.\n\n'
          'Đặt google-services.json đúng project vào android/app, '
          'sau đó dừng app và chạy lại flutter run.\n\n'
          'Xem README.md để cấu hình Firebase và SHA.';
    }
  }
  runApp(MyApp(setupError: setupError));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.setupError,
    this.authService,
    this.notificationService,
  });

  final String? setupError;
  final AuthService? authService;
  final NotificationService? notificationService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.4 & 10.5',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: setupError == null
          ? AuthScreen(
              authService: authService ?? AuthService(),
              notificationService: notificationService,
            )
          : Scaffold(
              appBar: AppBar(title: const Text('Thiết lập Firebase')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(setupError!),
                ),
              ),
            ),
    );
  }
}
