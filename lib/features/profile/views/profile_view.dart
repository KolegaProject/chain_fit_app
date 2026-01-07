import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_viewmodel.dart';
import '../model/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Fetch sekali saat page dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().fetchProfile();
    });
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

  Future<void> _confirmLogout() async {
    final vm = context.read<ProfileViewModel>();

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

    final ok = await vm.logout();

    if (!mounted) return;

    if (!ok && vm.errorMessage != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
      vm.clearError();
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

Future<void> _openEditProfileSheet() async {
  final data = context.read<ProfileViewModel>().data;
  if (data == null) return;

  final user = data.user;

  TextEditingController? usernameC;
  TextEditingController? nameC;

  File? selectedImage;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      usernameC ??= TextEditingController(text: user.username);
      nameC ??= TextEditingController(text: user.name);

      return StatefulBuilder(
        builder: (ctx, setModalState) {
          Future<void> pickImage() async {
            final x = await _picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 85,
            );
            if (x == null) return;

            if (!ctx.mounted) return;
            if (!Navigator.of(ctx).canPop()) return;

            setModalState(() => selectedImage = File(x.path));
          }

          return Consumer<ProfileViewModel>(
            builder: (context, vm, _) {
              Future<void> save() async {
                final ok = await vm.updateProfile(
                  username: usernameC!.text,
                  name: nameC!.text,
                  imageFile: selectedImage,
                );

                if (!ctx.mounted) return;

                if (!ok && vm.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(vm.errorMessage!)),
                  );
                  vm.clearError();
                  return;
                }

                if (Navigator.of(ctx).canPop()) Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil berhasil diperbarui")),
                );
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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
                              onPressed: vm.isSaving ? null : pickImage,
                              icon: const Icon(Icons.photo),
                              label: const Text("Ganti Foto"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: usernameC,
                        enabled: !vm.isSaving,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: nameC,
                        enabled: !vm.isSaving,
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
                          onPressed: vm.isSaving ? null : save,
                          child: vm.isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
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
      );
    },
  ).whenComplete(() {
    usernameC?.dispose();
    nameC?.dispose();
    usernameC = null;
    nameC = null;
  });
}


  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    // tampilkan error 1x (opsional)
    if (vm.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
        vm.clearError();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Profil"),
        automaticallyImplyLeading: false,
        leading: const SizedBox.shrink(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF5F6FA),
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: vm.isLoggingOut
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
            onPressed: vm.isLoggingOut ? null : _confirmLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: vm.fetchProfile,
        child: _buildBody(vm),
      ),
    );
  }

  Widget _buildBody(ProfileViewModel vm) {
    if (vm.isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 180),
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 24),
        ],
      );
    }

    final data = vm.data;
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GymTileLarge(name: g.name),
          );
        }).toList(),
      ],
    );
  }
}

// ===== Styles / Widgets (tetap sama punyamu) =====

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

class _GymTileLarge extends StatelessWidget {
  final String name;

  const _GymTileLarge({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF636AE8), width: 1.2),
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
              color: const Color(0xFFE9EBFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 22,
              color: Color(0xFF636AE8),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w900,
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
