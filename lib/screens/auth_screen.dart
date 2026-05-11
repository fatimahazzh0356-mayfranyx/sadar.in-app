import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> submitAuth() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString(
      'userName',
      isLogin ? 'Pengguna Sadar.in' : nameController.text.trim(),
    );
    await prefs.setString('userEmail', emailController.text.trim());

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainShell(),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(size.horizontalPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.maxContentWidth),
              child: Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pink.withOpacity(0.10),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/logo/sadarin_logo.png',
                        width: 96,
                        height: 96,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      isLogin ? 'Masuk Akun' : 'Buat Akun',
                      style: TextStyle(
                        fontFamily: 'Melodrama',
                        fontSize: size.responsiveFont(34, tablet: 42),
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isLogin
                          ? 'Masuk untuk melanjutkan ke ruang amanmu.'
                          : 'Daftar simpel dulu, tanpa ribet.',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        height: 1.5,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (!isLogin)
                      AuthInput(
                        controller: nameController,
                        hint: 'Nama',
                        icon: Icons.person_rounded,
                      ),

                    AuthInput(
                      controller: emailController,
                      hint: 'Email',
                      icon: Icons.email_rounded,
                    ),

                    AuthInput(
                      controller: passwordController,
                      hint: 'Password',
                      icon: Icons.lock_rounded,
                      obscure: true,
                    ),

                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: submitAuth,
                      child: Container(
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.pink, AppColors.softPink],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          isLogin ? 'Masuk' : 'Daftar',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? 'Belum punya akun? Daftar'
                              : 'Sudah punya akun? Masuk',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: AppColors.pink,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;

  const AuthInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontFamily: 'Poppins'),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.pink),
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.mutedText,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}