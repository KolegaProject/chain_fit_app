class ProfileResponse {
  final int code;
  final String status;
  final int recordsTotal;
  final ProfileData data;

  ProfileResponse({
    required this.code,
    required this.status,
    required this.recordsTotal,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      recordsTotal: json['recordsTotal'] ?? 0,
      data: ProfileData.fromJson(json['data'] ?? const {}),
    );
  }
}

class ProfileData {
  final AppUser user;
  final List<GymMini> gyms;
  final int? defaultGymId;

  ProfileData({
    required this.user,
    required this.gyms,
    required this.defaultGymId,
  });

  GymMini? get defaultGym {
    if (defaultGymId == null) return null;
    try {
      return gyms.firstWhere((g) => g.id == defaultGymId);
    } catch (_) {
      return null;
    }
  }

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final gymsJson = (json['gyms'] as List?) ?? [];
    return ProfileData(
      user: AppUser.fromJson(json['user'] ?? const {}),
      gyms: gymsJson.map((e) => GymMini.fromJson(e)).toList(),
      defaultGymId: json['defaultGymId'],
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
    required this.profileImage,
  });

  String get initial {
    final u = username.trim();
    if (u.isEmpty) return 'U';
    return u[0].toUpperCase();
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'MEMBER',
      profileImage: json['profileImage'],
    );
  }
}

class GymMini {
  final int id;
  final String name;

  GymMini({required this.id, required this.name});

  factory GymMini.fromJson(Map<String, dynamic> json) {
    return GymMini(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
