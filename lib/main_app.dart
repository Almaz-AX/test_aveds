import 'package:aveds_test/features/auth/auth_screen.dart';
import 'package:aveds_test/features/auth/bloc/auth_bloc.dart';
import 'package:aveds_test/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFFF2796B),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Color(0xFFF2796B),
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
           if (state is AuthSuccessState) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
              settings: RouteSettings(arguments: {'jwt': state.jwt}),
            ),
            (route) => false,
          );
        }
        },
        child: AuthScreen(),
      ),
    );
  }
}
