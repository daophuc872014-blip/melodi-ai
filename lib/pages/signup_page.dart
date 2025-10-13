import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F3057),
              Color(0xFF00587A),
              Color(0xFFE75480),
              Color(0xFFFF8C69),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Tạo tài khoản',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 48),
                _buildTextField(hintText: 'Email', icon: Icons.email_outlined),
                const SizedBox(height: 20),
                _buildTextField(
                  hintText: 'Mật khẩu',
                  icon: Icons.lock_outline,
                  isObscured: _isPasswordObscured,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                    onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  hintText: 'Xác nhận mật khẩu',
                  icon: Icons.lock_outline,
                  isObscured: _isConfirmPasswordObscured,
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                    onPressed: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSignUpButton(),
                const SizedBox(height: 48),
                _buildLoginNavigation(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, required IconData icon, bool isObscured = false, Widget? suffixIcon}) {
    return TextField(
      obscureText: isObscured,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: const Color(0xFF5DE0E6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text('Đăng ký', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildLoginNavigation(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Đã có tài khoản? ',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
          children: [
            TextSpan(
              text: 'Đăng nhập',
              style: const TextStyle(color: Color(0xFF5DE0E6), fontWeight: FontWeight.bold, fontSize: 16),
              recognizer: TapGestureRecognizer()..onTap = () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
