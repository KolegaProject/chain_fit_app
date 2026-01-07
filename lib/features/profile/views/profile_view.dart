import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/profile_model.dart';
import '../service/profile_service.dart';
import 'package:chain_fit_app/features/profile/service/logout_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _service = ProfileService();
  final _logoutService = AuthLogout();
  final _picker = ImagePicker();

  Future<ProfileData>? _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getProfile();
  }

  Future<void> _refresh() async {
    setState(() => _future = _service.getProfile());
    await _future;
  }

  String _initialFrom(ProfileData data) {
    final u = data.user;

    final ini = (u.initial ?? '').trim();
    if (ini.isNotEmpty) return ini;

    final username = (u.username ?? '').trim();
    if (username.isNotEmpty) return username[0].toUpperCase();

    final name = (u.name ?? '').trim();
    if (name.isNotEmpty) return name[0].toUpperCase();

    return '?';
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Keluar"),
        content: const Text("Yakin ingin logout?"),
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

    try {
      await _logoutService.logout();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal logout: $e")));
    }
  }

  Future<void> _openEditProfileSheet(ProfileData data) async {
    final user = data.user;

    final usernameC = TextEditingController(text: user.username ?? '');
    final nameC = TextEditingController(text: user.name ?? '');

    File? selectedImage;
    bool saving = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        final photoUrl = (user.profileImage ?? '').trim();
        final initial = _initialFrom(data);

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            Future<void> pickImage() async {
              final x = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 85,
              );
              if (x == null) return;
              setModalState(() => selectedImage = File(x.path));
            }

            Future<void> save() async {
              if (saving) return;
              setModalState(() => saving = true);

              try {
                await _service.updateProfile(
                  username: usernameC.text.trim(),
                  name: nameC.text.trim(),
                  imageFile: selectedImage,
                );

                if (ctx.mounted && Navigator.of(ctx).canPop()) {
                  Navigator.pop(ctx);
                }

                await _refresh();

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

            Widget avatar() {
              if (selectedImage != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    selectedImage!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                );
              }

              if (photoUrl.isNotEmpty) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    photoUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _photoFallback(initial, size: 64),
                  ),
                );
              }

              return _photoFallback(initial, size: 64);
            }

            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
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
                    const Text(
                      "Edit Profil",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        avatar(),
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
      usernameC.dispose();
      nameC.dispose();
    });
  }

  static BoxDecoration _softCard() => BoxDecoration(
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

  static Widget _photoFallback(String initial, {double size = 64}) {
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<ProfileData>(
          future: _future,
          builder: (context, snap) {
            // loading
            if (snap.connectionState == ConnectionState.waiting) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(child: CircularProgressIndicator()),
                  SizedBox(height: 24),
                ],
              );
            }

            // error
            if (snap.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _ErrorCard(
                    message: "Gagal memuat profil:\n${snap.error}",
                    onRetry: _refresh,
                  ),
                ],
              );
            }

            // empty
            final data = snap.data;
            if (data == null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text("Data profil tidak tersedia.")),
                ],
              );
            }

            final user = data.user;
            final initial = _initialFrom(data);

            final title = (user.name ?? '').trim().isNotEmpty
                ? (user.name ?? '')
                : (user.username ?? '-');

            final email = (user.email ?? '-');
            final role = (user.role ?? 'MEMBER');
            final imageUrl = (user.profileImage ?? '').trim();

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              children: [
                // ===== Profile Header Card (dipertahankan) =====
                _ProfileHeaderCard(
                  title: title,
                  email: email,
                  role: role,
                  imageUrl: imageUrl.isEmpty ? null : imageUrl,
                  initial: initial,
                  onEdit: () => _openEditProfileSheet(data),
                ),
                const SizedBox(height: 14),

                // ===== Gym Terdaftar =====
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Gym Terdaftar",
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (data.gyms.isNotEmpty)
                      Text(
                        "${data.gyms.length}",
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF636AE8),
                        ),
                      ),
                  ],
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
                          child: const Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                          ),
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: _softCard(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F5F7),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 22,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              g.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ===== Widgets (header card dipertahankan) =====

class _ProfileHeaderCard extends StatelessWidget {
  final String title;
  final String email;
  final String role;
  final String? imageUrl;
  final String initial;
  final VoidCallback onEdit;

  const _ProfileHeaderCard({
    required this.title,
    required this.email,
    required this.role,
    required this.imageUrl,
    required this.initial,
    required this.onEdit,
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

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
