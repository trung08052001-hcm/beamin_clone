import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (event.email.isNotEmpty && event.password.isNotEmpty) {
      emit(const AuthSuccess('Đăng nhập thành công!'));
    } else {
      emit(const AuthFailure('Vui lòng điền đầy đủ thông tin'));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (event.phone.isNotEmpty) {
      emit(const AuthSuccess('Đăng ký thành công!'));
    } else {
      emit(const AuthFailure('Vui lòng nhập số điện thoại'));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (event.emailOrPhone.isNotEmpty) {
      emit(const AuthSuccess('Yêu cầu đã được gửi!'));
    } else {
      emit(const AuthFailure('Vui lòng nhập Email hoặc Số điện thoại'));
    }
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Sign out first to get the account picker
      await _googleSignIn.signOut();
      
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        emit(const AuthFailure('Đăng nhập Google đã bị huỷ'));
        return;
      }

      // Get the authentication details from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        emit(const AuthSuccess(
            'Đăng nhập Google thành công!'));
      } else {
        emit(const AuthFailure('Không thể đăng nhập với Google'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure('Lỗi: ${e.message}'));
    } catch (e) {
      emit(AuthFailure('Đã xảy ra lỗi: $e'));
    }
  }
}
