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

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
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

    if (mounted) {
      AppAlerts.showSuccess(
        context,
        registerVM.successMessage ?? 'Registrasi berhasil!',
      );
    }

    final loginSuccess = await loginVM.login(username, password);

    if (loginVM.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppAlerts.showError(context, loginVM.errorMessage!);
        loginVM.clearError();
      });
      return;
    }

    if (loginSuccess && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SearchGymView()),
      );
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F3F6),
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
      suffixIcon: suffixIcon,
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: _handleBack,
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Pendaftaran Gym',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Buat akun untuk melanjutkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                TextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Nama Lengkap',
                    hint: 'John Doe',
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Username',
                    hint: 'johnd0e',
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Email',
                    hint: 'john@email.com',
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  textInputAction: TextInputAction.done,
                  decoration: _inputDecoration(
                    label: 'Password',
                    hint: 'Enter your password',
                    suffixIcon: IconButton(
                      splashRadius: 20,
                      tooltip: _isPasswordHidden
                          ? 'Show password'
                          : 'Hide password',
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _isPasswordHidden = !_isPasswordHidden);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleRegisterAndLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF636AE8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
