// Model for login akun (can be expanded as needed)
class LoginAkunModel {
  final String username;
  final String password;

  LoginAkunModel({required this.username, required this.password});
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;
  final String name;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.name,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['data']['accessToken'] ?? '',
      refreshToken: json['data']['refreshToken'] ?? '',
      userId: json['data']['userId'] ?? '',
      email: json['data']['email'] ?? '',
      name: json['data']['name'] ?? '',
    );
  }
}
