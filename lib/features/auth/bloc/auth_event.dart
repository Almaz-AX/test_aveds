part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthCheckEvent extends AuthEvent {}

final class AuthSendedCodeEvent extends AuthEvent {
  final String emailAdress;

  AuthSendedCodeEvent({required this.emailAdress});
}

final class AuthVerifyCodeEvent extends AuthEvent {
  final String emailAdress;
  final int code;

  AuthVerifyCodeEvent({required this.emailAdress, required this.code});
}

final class AuthLogoutEvent extends AuthEvent {}
