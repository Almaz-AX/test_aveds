import 'package:aveds_test/features/auth/auth_screen.dart';
import 'package:aveds_test/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final jwt = args?['jwt'] as String?;
    if (jwt != null) {
      BlocProvider.of<HomeBloc>(context).add(HomeGetUserEvent(jwt: jwt));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authorized'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogoutEvent());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) {
                    return AuthScreen();
                  },
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body:
          jwt == null
              ? Center(child: Text('Something went wrong, try to auth again'))
              : BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  switch (state) {
                    case HomeLoading _:
                      return Center(child: CircularProgressIndicator());
                    case HomeLoaded _:
                      return UserWidget(userId: state.userId);
                    case HomeFailure _:
                      return Center(
                        child: Text('Something went wrong, try to auth again'),
                      );
                  }
                },
              ),
    );
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Text('You are authorized'), Text('User ID: $userId')],
      ),
    );
  }
}
