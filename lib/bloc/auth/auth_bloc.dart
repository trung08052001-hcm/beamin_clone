import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
    on<FacebookLoginRequested>(_onFacebookLoginRequested);
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này';
      case 'wrong-password':
        return 'Mật khẩu không chính xác';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'user-disabled':
        return 'Tài khoản đã bị vô hiệu hóa';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng';
      case 'operation-not-allowed':
        return 'Phương thức đăng nhập chưa được kích hoạt';
      case 'weak-password':
        return 'Mật khẩu quá yếu, vui lòng dùng ít nhất 6 ký tự';
      case 'too-many-requests':
        return 'Quá nhiều yêu cầu, vui lòng thử lại sau';
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không chính xác';
      default:
        return 'Đã xảy ra lỗi, vui lòng thử lại';
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    if (event.email.isEmpty || event.password.isEmpty) {
      emit(const AuthFailure('Vui lòng điền đầy đủ thông tin'));
      return;
    }

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password,
      );
      emit(const AuthSuccess('Đăng nhập thành công!'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      emit(AuthFailure('Đã xảy ra lỗi: $e'));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    if (event.email.isEmpty || event.password.isEmpty || event.name.isEmpty) {
      emit(const AuthFailure('Vui lòng điền đầy đủ thông tin'));
      return;
    }

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(event.name.trim());

      emit(const AuthSuccess('Đăng ký thành công!'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      emit(AuthFailure('Đã xảy ra lỗi: $e'));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    if (event.email.isEmpty) {
      emit(const AuthFailure('Vui lòng nhập email'));
      return;
    }

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: event.email.trim());
      emit(
        const AuthSuccess(
          'Đã gửi email khôi phục mật khẩu! Vui lòng kiểm tra hộp thư.',
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      emit(AuthFailure('Đã xảy ra lỗi: $e'));
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
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        emit(const AuthSuccess('Đăng nhập Google thành công!'));
      } else {
        emit(const AuthFailure('Không thể đăng nhập với Google'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure('Lỗi: ${e.message}'));
    } catch (e) {
      emit(AuthFailure('Đã xảy ra lỗi: $e'));
    }
  }

  Future<void> _onFacebookLoginRequested(
    FacebookLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Trigger the Facebook sign-in flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken?.tokenString;
        if (accessToken == null) {
          emit(const AuthFailure('Không thể lấy access token từ Facebook'));
          return;
        }

        final facebookAuthCredential = FacebookAuthProvider.credential(
          accessToken,
        );

        final userCredential = await _firebaseAuth.signInWithCredential(
          facebookAuthCredential,
        );

        if (userCredential.user != null) {
          emit(const AuthSuccess('Đăng nhập Facebook thành công!'));
        } else {
          emit(const AuthFailure('Không thể đăng nhập với Facebook'));
        }
      } else if (result.status == LoginStatus.cancelled) {
        emit(const AuthFailure('Đăng nhập Facebook đã bị huỷ'));
      } else {
        emit(AuthFailure('Lỗi Facebook: ${result.message}'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure('Lỗi: ${e.message}'));
    } catch (e) {
      emit(AuthFailure('Đã xảy ra lỗi: $e'));
    }
  }
}
