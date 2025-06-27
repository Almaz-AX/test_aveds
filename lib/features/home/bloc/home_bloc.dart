import 'package:aveds_test/features/auth/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthService auth;
  HomeBloc({required this.auth}) : super(HomeLoading()) {
    on<HomeGetUserEvent>((event, emit) async {
      try {
        final userId = await auth.getUserid(event.jwt);
        emit(HomeLoaded(userId: userId));
      } catch (e) {
        print(e);
        emit(HomeFailure());
      }
    });
  }
}
