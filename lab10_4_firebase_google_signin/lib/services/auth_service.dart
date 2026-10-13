import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // GoogleSignIn v7 dùng instance + initialize(), không dùng GoogleSignIn().
  final GoogleSignIn _google = GoogleSignIn.instance;
  Future<void>? _initialization;

  Stream<User?> authStateChanges() => FirebaseAuth.instance.authStateChanges();

  Future<void> _initializeGoogle() {
    return _initialization ??= _google.initialize();
  }

  Future<void> signInWithGoogle() async {
    await _initializeGoogle();
    // Mở bảng chọn tài khoản Google. Hủy sẽ ném GoogleSignInException.
    final googleUser = await _google.authenticate();
    final idToken = googleUser.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-google-token',
        message: 'Google không trả về ID token.',
      );
    }

    // Đổi thông tin xác thực Google thành phiên đăng nhập Firebase.
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
    // authStateChanges() tự phát User mới để giao diện chuyển sang hồ sơ.
  }

  Future<void> signOut() async {
    try {
      await _initializeGoogle();
      await _google.signOut();
    } finally {
      // Vẫn xóa phiên Firebase nếu thao tác đăng xuất Google gặp lỗi.
      await FirebaseAuth.instance.signOut();
    }
  }
}

String authErrorMessage(Object error) {
  if (error is GoogleSignInException) {
    switch (error.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'Đăng nhập đã bị hủy. Bạn có thể thử lại.';
      case GoogleSignInExceptionCode.clientConfigurationError:
      case GoogleSignInExceptionCode.providerConfigurationError:
        return 'Cấu hình Google Sign-In chưa đúng. Kiểm tra Firebase, SHA và google-services.json.';
      default:
        return 'Không thể đăng nhập Google. Vui lòng kiểm tra mạng và thử lại.';
    }
  }
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'network-request-failed':
        return 'Không có kết nối mạng. Vui lòng thử lại.';
      case 'operation-not-allowed':
        return 'Chưa bật Google trong Firebase Authentication.';
      case 'user-disabled':
        return 'Tài khoản đã bị vô hiệu hóa.';
      case 'account-exists-with-different-credential':
        return 'Email này đã dùng phương thức đăng nhập khác.';
      default:
        return 'Đăng nhập Firebase thất bại (${error.code}). Vui lòng thử lại.';
    }
  }
  return 'Có lỗi xảy ra. Vui lòng thử lại.';
}
