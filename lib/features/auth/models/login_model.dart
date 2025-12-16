// Model untuk Data yang dikirim (Request)
class LoginRequestModel {
  final String username;
  final String password;

  LoginRequestModel({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

// Model untuk Data yang diterima (Response)
class LoginResponseModel {
  final String accessToken;
  final String refreshToken;

  LoginResponseModel({required this.accessToken, required this.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // Menyesuaikan struktur JSON dari backend Anda: json['data']['access_token']
    final data = json['data'] ?? {};
    return LoginResponseModel(
      accessToken: data['access_token'] ?? '',
      refreshToken: data['refresh_token'] ?? '',
    );
  }
}