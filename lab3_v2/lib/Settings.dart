class Settings {
  String theme = "light";

  // tạo biến ẩn tĩnh để lưu bản sao duy nhất (cache)
  static final Settings _instance = Settings._internal();

  // định nghĩa một private constructor bằng _
  Settings._internal() {
    print("Khoi tạo Settings lần đầu ...");
  }

  // sử dụng từ khoá factory cho constructor mặc định
  // khác với constructor thường luôn tạo vùng nớ mới, factory constructore
  // cho phép quyết đinhhj trả về cái gì (ở đây trả về bản cache)
  factory Settings() {
    return _instance;
  }
}