import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService auth;
  AuthBloc({required this.auth}) : super(AuthInitialState()) {
    on<AuthCheckEvent>(_onAuthCheckEvent);
    on<AuthSendedCodeEvent>(_onAuthSendedCodeEvent);
    on<AuthVerifyCodeEvent>(_onAuthVerifyCodeEvent);
    on<AuthLogoutEvent>(_onAuthLogoutEvent);
  }

  Future<void> _onAuthCheckEvent(
    AuthCheckEvent event,
    Emitter<AuthState> emit,
  ) async {
    final (jwt, rt) = await auth.getTokens();
    if (jwt == null || rt == null) {
      emit(AuthUnauthState());
    } else {
      emit(AuthSuccessState(jwt: jwt));
    }
  }

  Future<void> _onAuthSendedCodeEvent(
    AuthSendedCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await auth.sendCodeToEmail(event.emailAdress);
      emit(AuthCodeSended());
    } catch (e) {
      emit(AuthFailureState());
    }
  }

  Future<void> _onAuthVerifyCodeEvent(
    AuthVerifyCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await auth.getJWTRT(event.emailAdress, event.code);
      final (jwt, rt) = await auth.getTokens();
      if (jwt == null || rt == null) {
        emit(AuthFailureState());
      } else {
        emit(AuthSuccessState(jwt: jwt));
      }
    } catch (e) {
      emit(AuthFailureState());
    }
  }

  Future<void> _onAuthLogoutEvent(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await auth.clearTokens();
  }
}
