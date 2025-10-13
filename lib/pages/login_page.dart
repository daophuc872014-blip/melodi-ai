import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Biến trạng thái để quản lý việc ẩn/hiện mật khẩu
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Giữ nền gradient nhất quán với toàn bộ ứng dụng
        width: double.infinity,
        height: double.infinity,
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
          // SingleChildScrollView giúp màn hình không bị lỗi tràn khi bàn phím hiện lên
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tiêu đề
                const Text(
                  'Đăng nhập',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),

                // Ô nhập Email
                _buildTextField(
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),

                // Ô nhập Mật khẩu
                _buildTextField(
                  hintText: 'Mật khẩu',
                  icon: Icons.lock_outline,
                  isObscured: _isPasswordObscured,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Nút Đăng nhập
                _buildLoginButton(),
                const SizedBox(height: 32),

                // Dòng chữ "Hoặc đăng nhập với"
                _buildDivider(),
                const SizedBox(height: 32),

                // Nút đăng nhập Google
                _buildGoogleLoginButton(),
                const SizedBox(height: 48),

                // Dòng chữ điều hướng sang trang Đăng ký
                _buildSignupNavigation(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper cho các ô TextField để tái sử dụng code
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isObscured = false,
    Widget? suffixIcon,
  }) {
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  
  // Nút đăng nhập chính
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: const Color(0xFF5DE0E6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text(
        'Đăng nhập',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // Dòng kẻ phân cách
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Hoặc đăng nhập với', style: TextStyle(color: Colors.white.withOpacity(0.8))),
        ),
        Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
      ],
    );
  }

  // Nút đăng nhập bằng Google
  Widget _buildGoogleLoginButton() {
    // Tạm thời dùng Icon, chúng ta sẽ thêm ảnh logo sau
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.g_mobiledata_rounded, color: Colors.white, size: 32),
      label: const Text(
        'Tiếp tục với Google',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        side: BorderSide(color: Colors.white.withOpacity(0.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  // Text điều hướng sang trang đăng ký
  Widget _buildSignupNavigation(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Chưa có tài khoản? ',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
          children: [
            TextSpan(
              text: 'Đăng ký ngay',
              style: const TextStyle(
                color: Color(0xFF5DE0E6),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              // Thêm sự kiện nhấn để điều hướng
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.push('/signup');
                },
            ),
          ],
        ),
      ),
    );
  }
}
