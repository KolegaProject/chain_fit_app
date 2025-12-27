class UserProfileResponse {
  final int code;
  final String status;
  final int recordsTotal;
  final UserProfileData data;
  final dynamic errors;

  UserProfileResponse({
    required this.code,
    required this.status,
    required this.recordsTotal,
    required this.data,
    this.errors,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      recordsTotal: json['recordsTotal'] ?? 0,
      data: UserProfileData.fromJson(json['data'] ?? {}),
      errors: json['errors'],
    );
  }
}

class UserProfileData {
  final AppUser user;
  final List<SimpleGym> gyms;
  final int defaultGymId;

  UserProfileData({
    required this.user,
    required this.gyms,
    required this.defaultGymId,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    final gymsJson = (json['gyms'] as List?) ?? [];
    return UserProfileData(
      user: AppUser.fromJson(json['user'] ?? {}),
      gyms: gymsJson.map((e) => SimpleGym.fromJson(e)).toList(),
      defaultGymId: json['defaultGymId'] ?? 0,
    );
  }
}

class AppUser {
  final int id;
  final String username;
  final String email;
  final String role;
  final String? profileImage;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.profileImage,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profileImage'],
    );
  }
}

class SimpleGym {
  final int id;
  final String name;

  SimpleGym({required this.id, required this.name});

  factory SimpleGym.fromJson(Map<String, dynamic> json) {
    return SimpleGym(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
