part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final String userId;

  HomeLoaded({required this.userId});
}

final class HomeFailure extends HomeState{}