import 'package:chain_fit_app/features/auth/viewmodels/login_viewmodel.dart';
import 'package:chain_fit_app/features/auth/viewmodels/register_viewmodel.dart';
import 'package:chain_fit_app/features/onboarding/view/onboarding.dart';
import 'package:chain_fit_app/features/search_gym/views/search_gym_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_alerts.dart';

class RegisterGymScreen extends StatefulWidget {
  const RegisterGymScreen({super.key});

  @override
  State<RegisterGymScreen> createState() => _RegisterGymScreenState();
}

class _RegisterGymScreenState extends State<RegisterGymScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegisterAndLogin() async {
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      AppAlerts.showError(context, "Semua field harus diisi");
      return;
    }

    final registerVM = context.read<RegisterViewModel>();
    final loginVM = context.read<LoginViewModel>();

    // 1) Register
    final regSuccess = await registerVM.register(
      name: name,
      username: username,
      email: email,
      password: password,
    );

    if (registerVM.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppAlerts.showError(context, registerVM.errorMessage!);
        registerVM.clearError();
      });
      return;
    }

    if (!regSuccess) return;

    // Optional: kasih info sukses register
    if (mounted) {
      AppAlerts.showSuccess(
        context,
        registerVM.successMessage ?? 'Registrasi berhasil!',
      );
    }

    // 2) Auto Login
    final loginSuccess = await loginVM.login(username, password);

    if (loginVM.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppAlerts.showError(context, loginVM.errorMessage!);
        loginVM.clearError();
      });
      return;
    }

    if (loginSuccess && mounted) {
      // 3) Redirect ke SearchGymView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SearchGymView()),
      );
    }
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F3F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registerVM = context.watch<RegisterViewModel>();
    final loginVM = context.watch<LoginViewModel>();

    final isLoading = registerVM.isLoading || loginVM.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,

        // ini biar kita kontrol tombol back sendiri
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // kalau sebelumnya kamu pake pushReplacement, biasanya stack kosong
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              );
            }
          },
        ),

        title: const Text(
          'Pendaftaran Gym',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              // Avatar Icon (seperti contoh)
              Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                        color: Colors.black.withOpacity(0.10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF636AE8)),
                ),
              ),

              const SizedBox(height: 22),

              // Nama
              const Text(
                'Nama Lengkap',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: _fieldDecoration(
                  label: '',
                  hint: 'Masukkan nama lengkap Anda',
                ),
              ),

              const SizedBox(height: 16),

              // Username (karena register kamu butuh ini)
              const Text(
                'Username',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                decoration: _fieldDecoration(
                  label: '',
                  hint: 'Masukkan username Anda',
                ),
              ),

              const SizedBox(height: 16),

              // Email
              const Text(
                'Alamat Email',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _fieldDecoration(
                  label: '',
                  hint: 'Masukkan alamat email Anda',
                ),
              ),

              const SizedBox(height: 16),

              // Password
              const Text(
                'Password',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordHidden,
                decoration:
                    _fieldDecoration(
                      label: '',
                      hint: 'Masukkan password Anda',
                    ).copyWith(
                      suffixIcon: IconButton(
                        splashRadius: 20,
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black.withOpacity(0.55),
                        ),
                        onPressed: () {
                          setState(
                            () => _isPasswordHidden = !_isPasswordHidden,
                          );
                        },
                      ),
                    ),
              ),

              const SizedBox(height: 140), // biar tombol kebawah mirip contoh
            ],
          ),
        ),
      ),

      // Bottom button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleRegisterAndLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF636AE8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Daftar Sekarang',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
