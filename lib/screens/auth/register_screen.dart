import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../constants/colors.dart';
import '../../router/app_router.gr.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/social_login_button.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không khớp'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu phải có ít nhất 6 ký tự'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(SignupRequested(email, password, name));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.router.replaceAll([const MainRoute()]);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => context.router.back(),
          ),
          title: Text(
            'Đăng ký',
            style: GoogleFonts.notoSans(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  title: 'Bắt đầu ngay!',
                  subtitle:
                      'Trở thành thành viên của gia đình Baemin để nhận được vô vàn ưu đãi hấp dẫn.',
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  controller: _nameController,
                  label: 'Họ và tên',
                  hintText: 'Nhập họ và tên của bạn',
                  prefixIcon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Nhập email của bạn',
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  hintText: 'Nhập mật khẩu (ít nhất 6 ký tự)',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: 'Xác nhận mật khẩu',
                  hintText: 'Nhập lại mật khẩu',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return AuthButton(
                      text: 'Đăng ký',
                      isLoading: state is AuthLoading,
                      onPressed: _onRegister,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Bằng việc nhấn "Đăng ký", bạn đồng ý với các Điều khoản & Chính sách bảo mật của chúng tôi.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade200)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Hoặc tiếp tục với',
                        style: GoogleFonts.notoSans(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade200)),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    SocialLoginButton(
                      icon: Icons.g_mobiledata,
                      label: 'Google',
                      onTap: () {
                        context.read<AuthBloc>().add(
                          const GoogleLoginRequested(),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    SocialLoginButton(
                      icon: Icons.facebook,
                      label: 'Facebook',
                      color: const Color(0xFF1877F2),
                      onTap: () {
                        context.read<AuthBloc>().add(
                          const FacebookLoginRequested(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đã có tài khoản? ',
                      style: GoogleFonts.notoSans(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.router.push(const LoginRoute());
                      },
                      child: Text(
                        'Đăng nhập ngay',
                        style: GoogleFonts.notoSans(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
