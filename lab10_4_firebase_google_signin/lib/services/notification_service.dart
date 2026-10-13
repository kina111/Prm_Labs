import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  static const notificationId = 105;
  static const channelId = 'lab_10_5';

  Future<void> _initialize() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError('Bài lab thông báo hiện cấu hình cho Android.');
    }
    if (_initialized) return;
    // Icon trắng nền trong suốt nằm trong android/app/src/main/res/drawable.
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()!
        .createNotificationChannel(
          const AndroidNotificationChannel(
            channelId,
            'Thông báo Lab 10.5',
            description: 'Thông báo sau khi đăng nhập thành công',
            importance: Importance.high,
          ),
        );
    _initialized = true;
  }

  // false: chưa được cấp quyền; UI hướng dẫn người dùng bật trong Cài đặt.
  Future<bool> showLoginSuccessNotification() async {
    await _initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()!;
    // Android 13+ hiện hộp xin quyền; hỏi sau khi đăng nhập thành công.
    final granted = await android.requestNotificationsPermission();
    if (granted != true) return false;

    await _plugin.show(
      id: notificationId,
      title: 'Đăng nhập thành công',
      body: 'Chào mừng bạn đến với ứng dụng!',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Thông báo Lab 10.5',
          channelDescription: 'Thông báo sau khi đăng nhập thành công',
          icon: 'ic_notification',
          importance: Importance.high,
          priority: Priority.high,
          autoCancel: true,
        ),
      ),
    );
    // Gửi lại cùng ID sẽ cập nhật thông báo cũ, tránh tạo hàng loạt thông báo.
    return true;
  }
}
