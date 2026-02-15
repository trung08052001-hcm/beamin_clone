import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
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
}
