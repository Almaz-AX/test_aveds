part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthCodeSended extends AuthState {}

final class AuthSuccessState extends AuthState {
  final String jwt;

  AuthSuccessState({required this.jwt});
}

final class AuthUnauthState extends AuthState {}

final class AuthFailureState extends AuthState {}
