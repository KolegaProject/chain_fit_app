import 'package:flutter/material.dart';
import '../model/profile_model.dart';
import '../service/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _service = ProfileService();

  ProfileData? _data;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _service.getProfile();

      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF5F6FA),
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(onRefresh: _fetchProfile, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 180),
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 24),
        ],
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _ErrorCard(
            message: "Gagal memuat profil:\n$_errorMessage",
            onRetry: _fetchProfile,
          ),
        ],
      );
    }

    if (_data == null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 180),
          Center(child: Text("Data profil tidak tersedia.")),
        ],
      );
    }

    final data = _data!;
    final user = data.user;
    final initial = (user.initial.isNotEmpty)
        ? user.initial
        : (user.username.isNotEmpty ? user.username[0].toUpperCase() : "?");

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        _ProfileHeaderCard(
          username: user.username,
          email: user.email,
          role: user.role,
          imageUrl: user.profileImage,
          initial: initial,
        ),
        const SizedBox(height: 14),

        _SectionTitle(
          title: "Gym Terdaftar",
          trailing: data.gyms.isNotEmpty ? "${data.gyms.length}" : null,
        ),
        const SizedBox(height: 10),

        if (data.gyms.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _softCard(),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F2F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.info_outline, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Belum ada gym terdaftar.",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

        ...data.gyms.map((g) {
          final isDefault = data.defaultGymId == g.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GymTileLarge(name: g.name, isDefault: isDefault),
          );
        }).toList(),
      ],
    );
  }
}

// ===== Styles / Widgets =====

BoxDecoration _softCard() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 18,
      offset: const Offset(0, 10),
    ),
  ],
);

class _ProfileHeaderCard extends StatelessWidget {
  final String username;
  final String email;
  final String role;
  final String? imageUrl;
  final String initial;

  const _ProfileHeaderCard({
    required this.username,
    required this.email,
    required this.role,
    required this.imageUrl,
    required this.initial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF636AE8), Color(0xFF7C5CFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF636AE8).withOpacity(0.25),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _Avatar(imageUrl: imageUrl, initial: initial, size: 64),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                _RolePill(role: role),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? imageUrl;
  final String initial;
  final double size;

  const _Avatar({
    required this.imageUrl,
    required this.initial,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
            )
          : _fallback(),
    );
  }

  Widget _fallback() => Center(
    child: Text(
      initial,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    ),
  );
}

class _RolePill extends StatelessWidget {
  final String role;
  const _RolePill({required this.role});

  @override
  Widget build(BuildContext context) {
    final r = role.isEmpty ? "MEMBER" : role.toUpperCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Text(
        r,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF636AE8),
            ),
          ),
      ],
    );
  }
}

/// ✅ lebih besar + tanpa badge DEFAULT
class _GymTileLarge extends StatelessWidget {
  final String name;
  final bool isDefault;

  const _GymTileLarge({required this.name, required this.isDefault});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDefault ? const Color(0xFFF3F4FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDefault ? const Color(0xFF636AE8) : Colors.grey.shade200,
          width: isDefault ? 1.2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ), // ✅ lebih besar
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46, // ✅ lebih besar
            decoration: BoxDecoration(
              color: isDefault
                  ? const Color(0xFFE9EBFF)
                  : const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: 22,
              color: isDefault ? const Color(0xFF636AE8) : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: isDefault ? FontWeight.w900 : FontWeight.w800,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _softCard(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 44),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text("Coba Lagi")),
        ],
      ),
    );
  }
}
