part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeGetUserEvent extends HomeEvent {
  final String jwt;

  HomeGetUserEvent({required this.jwt});
}
