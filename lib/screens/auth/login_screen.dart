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
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              'Đăng nhập',
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    title: 'Chào mừng trở lại!',
                    subtitle:
                        'Hãy đăng nhập để tiếp tục khám phá những món ngon nhất từ Baemin.',
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email / Tên đăng nhập',
                    hintText: 'Nhập email của bạn',
                    prefixIcon: Icons.mail_outline_rounded,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu',
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.router.push(const ForgotPasswordRoute());
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                      ),
                      child: Text(
                        'Quên mật khẩu?',
                        style: GoogleFonts.notoSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AuthButton(
                        text: 'Đăng nhập',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            LoginRequested(
                              _emailController.text,
                              _passwordController.text,
                            ),
                          );
                        },
                      );
                    },
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
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bạn mới biết đến Baemin? ',
                        style: GoogleFonts.notoSans(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.router.push(const RegisterRoute());
                        },
                        child: Text(
                          'Đăng ký ngay',
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
