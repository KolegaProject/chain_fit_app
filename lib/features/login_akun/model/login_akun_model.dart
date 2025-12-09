// Model for login akun (can be expanded as needed)
class LoginAkunModel {
  final String username;
  final String password;

  LoginAkunModel({required this.username, required this.password});
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;

  LoginResponse({required this.accessToken, required this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['data']['access_token'] ?? '',
      refreshToken: json['data']['refresh_token'] ?? '',
    );
  }
}
