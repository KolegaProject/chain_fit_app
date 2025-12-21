// Model untuk Data yang dikirim (Request)
class RegisterRequestModel {
  final String name;
  final String username;
  final String email;
  final String password;

  RegisterRequestModel({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}

// Model untuk Data yang diterima (Response)
class RegisterResponseModel {
  final String message;

  RegisterResponseModel({required this.message});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    // Menyesuaikan struktur JSON dari backend Anda: json['message']
    return RegisterResponseModel(message: json['message'] ?? '');
  }
}
