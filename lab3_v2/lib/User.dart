class User {
  String name;
  String email;

  User.fromJson(Map<String, dynamic> json) :
    name = json['name'] ?? 'Unknown',
    email = json['email'] ?? 'Unknown';

  @override
  String toString() {
    return 'User(name: $name, email: $email)';
  }
}