import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../../../core/utils/app_alerts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      AppAlerts.showError(context, "Username dan password tidak boleh kosong");
      return;
    }

    // Panggil ViewModel
    // listen: false karena kita memanggil fungsi, bukan mendengar perubahan UI di sini
    final viewModel = context.read<LoginViewModel>();
    final isSuccess = await viewModel.login(username, password);

    // Tampilkan Alert jika login gagal
    if (viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Menyuruh Flutter menjalankan kode SETELAH proses build & render selesai.
        AppAlerts.showError(context, viewModel.errorMessage!);
        viewModel.clearError(); // reset agar tidak muncul berulang
      });
    }

    if (isSuccess && mounted) {
      // Navigasi jika sukses
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch ViewModel untuk update UI saat loading / error
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      // appBar: AppBar(title: const Text('Login MVVM')),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Description
                const Text(
                  'Anda harus masuk dahulu untuk melanjutkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Error Message
                // if (viewModel.errorMessage != null)
                //   AppAlerts.showError(
                //     context,
                //     viewModel.errorMessage as String,
                //   ),

                // Username TextField
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'johnd0e',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password TextField
                TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    // suffixIcon: const Icon(Icons.visibility_off),
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
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF636AE8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
