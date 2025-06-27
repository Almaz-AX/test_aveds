import 'package:aveds_test/features/auth/auth_service.dart';
import 'package:aveds_test/features/auth/bloc/auth_bloc.dart';
import 'package:aveds_test/features/home/bloc/home_bloc.dart';
import 'package:aveds_test/main_app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authService = AuthService(dio: Dio(), prefs: prefs);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  AuthBloc(auth: authService)
                    ..add(AuthCheckEvent()),
        ),
        BlocProvider(create: (context) => HomeBloc(auth: authService)),
      ],
      child: const MainApp(),
    ),
  );
}
