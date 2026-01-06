class UpdateProfileResponse {
  final int code;
  final String status;
  final UpdateProfileData data;
  final dynamic errors;

  UpdateProfileResponse({
    required this.code,
    required this.status,
    required this.data,
    required this.errors,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      code: (json['code'] is int)
          ? json['code'] as int
          : int.tryParse('${json['code']}') ?? 0,
      status: json['status']?.toString() ?? '',
      data: UpdateProfileData.fromJson(
        (json['data'] is Map<String, dynamic>)
            ? json['data'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
      errors: json['errors'],
    );
  }
}

class UpdateProfileData {
  final int id;
  final String email;
  final String name;

  UpdateProfileData({
    required this.id,
    required this.email,
    required this.name,
  });

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) {
    return UpdateProfileData(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
