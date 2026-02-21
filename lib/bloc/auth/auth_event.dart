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
  final String email;
  final String password;
  final String name;

  const SignupRequested(this.email, this.password, this.name);

  @override
  List<Object> get props => [email, password, name];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
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
