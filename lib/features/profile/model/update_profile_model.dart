class UpdateProfileResponse {
  final int code;
  final String status;
  final UpdateProfileData data;

  UpdateProfileResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      data: UpdateProfileData.fromJson(json['data'] ?? const {}),
    );
  }
}

class UpdateProfileData {
  final int id;
  final String username;
  final String name;

  UpdateProfileData({
    required this.id,
    required this.username,
    required this.name,
  });

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) {
    return UpdateProfileData(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
