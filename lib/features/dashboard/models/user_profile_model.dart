class UserProfileModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final String? profileImage;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.profileImage,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {}; 
    
    final user = data['user'] ?? {}; 

    return UserProfileModel(
      id: user['id'] ?? 0,
      username: user['username'] ?? 'Guest',
      email: user['email'] ?? '-',
      role: user['role'] ?? 'MEMBER',
      profileImage: user['profileImage'],
    );
  }
}