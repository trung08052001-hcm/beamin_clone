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
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
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
                    controller: _phoneController,
                    label: 'Số điện thoại',
                    hintText: 'Nhập số điện thoại của bạn',
                    prefixIcon: Icons.phone_iphone_rounded,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AuthButton(
                        text: 'Tiếp tục',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            SignupRequested(_phoneController.text),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Bằng việc nhấn "Tiếp tục", bạn đồng ý với các Điều khoản & Chính sách bảo mật của chúng tôi.',
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
                ],
              ),
            ),
          ),
        ),
      );
  }
}
