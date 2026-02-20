part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  final String phone;

  const SignupRequested(this.phone);

  @override
  List<Object> get props => [phone];
}

class ResetPasswordRequested extends AuthEvent {
  final String emailOrPhone;

  const ResetPasswordRequested(this.emailOrPhone);

  @override
  List<Object> get props => [emailOrPhone];
}

class GoogleLoginRequested extends AuthEvent {
  const GoogleLoginRequested();

  @override
  List<Object> get props => [];
}

class FacebookLoginRequested extends AuthEvent {
  const FacebookLoginRequested();

  @override
  List<Object> get props => [];
}
