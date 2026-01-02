import 'dart:io';


import 'package:chain_fit_app/features/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:chain_fit_app/features/profile/service/logout_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/profile_model.dart';
import '../service/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _service = ProfileService();
  // final cache = CacheService();
  final ImagePicker _picker = ImagePicker();

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

  Widget _photoFallback(String initial, {double size = 64}) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
    );
  }

  Future<void> _openEditProfileSheet() async {
    if (_data == null) return;
    final user = _data!.user;

    TextEditingController? usernameC;
    TextEditingController? nameC;

    File? selectedImage;
    bool saving = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        // ✅ controller dibuat DI DALAM lifecycle bottomsheet
        usernameC ??= TextEditingController(text: user.username);
        nameC ??= TextEditingController(
          // kalau AppUser kamu punya field name, ganti ke: text: user.name
          text: user.name,
        );

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            Future<void> pickImage() async {
              final x = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 85,
              );
              if (x == null) return;

              // ✅ FIX: bottomsheet bisa saja sudah ketutup karena swipe/back
              if (!ctx.mounted) return;
              if (!Navigator.of(ctx).canPop()) return;

              setModalState(() => selectedImage = File(x.path));
            }

            Future<void> save() async {
              if (saving) return;
              setModalState(() => saving = true);
              try {
                await _service.updateProfile(
                  username: usernameC!.text,
                  name: nameC!.text,
                  imageFile: selectedImage,
                );

                // ✅ tutup modal dengan aman
                if (ctx.mounted && Navigator.of(ctx).canPop()) {
                  Navigator.pop(ctx);
                }

                await _fetchProfile();

                // await cache.removeCache(ApiConstants.profileCacheKey);

                if (mounted) {
                  context.read<DashboardViewModel>().loadDashboardData(
                    forceRefresh: true,
                  );
                }

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil berhasil diperbarui")),
                );
              } catch (e) {
                if (ctx.mounted) setModalState(() => saving = false);
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }

            final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
            final photoUrl = (user.profileImage ?? '').trim();

            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Center(
                      child: Text(
                        "Edit Profil",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: selectedImage != null
                              ? Image.file(
                                  selectedImage!,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                )
                              : (photoUrl.isNotEmpty
                                    ? Image.network(
                                        photoUrl,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _photoFallback(user.initial),
                                      )
                                    : _photoFallback(user.initial)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: saving ? null : pickImage,
                            icon: const Icon(Icons.photo),
                            label: const Text("Ganti Foto"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: usernameC,
                      enabled: !saving,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: nameC,
                      enabled: !saving,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: saving ? null : save,
                        child: saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Simpan"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // ✅ dispose controller tepat waktu saat bottomsheet benar2 selesai (swipe/close)
      usernameC?.dispose();
      nameC?.dispose();
      usernameC = null;
      nameC = null;
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await AuthLogout().logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout_rounded),
            onPressed: _logout,
          ),
        ],
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
          title: user.name.isNotEmpty ? user.name : user.username,
          email: user.email,
          role: user.role,
          imageUrl: user.profileImage,
          initial: initial,
          onEdit: _openEditProfileSheet,
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
  final String title;
  final String email;
  final String role;
  final String? imageUrl;
  final String initial;
  final VoidCallback onEdit; // ✅ tambah

  const _ProfileHeaderCard({
    required this.title,
    required this.email,
    required this.role,
    required this.imageUrl,
    required this.initial,
    required this.onEdit, // ✅ tambah
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                      title,
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
        ),

        // ✅ tombol edit di dalam card (pojok kanan atas)
        Positioned(
          top: 10,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withOpacity(0.22)),
                ),
                child: const Icon(Icons.edit, size: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
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
    final url = (imageUrl ?? '').trim();
    final hasImage = url.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.35),
            Colors.white.withOpacity(0.15),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
      ),
      padding: const EdgeInsets.all(2.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: hasImage
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.white.withOpacity(0.10),
                    child: const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: Colors.white.withOpacity(0.10),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
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
