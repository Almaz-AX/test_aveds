// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'auth_screen.dart';
import 'auth_service.dart';

class AuthInterceptor extends Interceptor {
  final AuthService authService;
  final Dio dio;
  final GlobalKey<NavigatorState> navigatorKey;
  AuthInterceptor({
    required this.authService,
    required this.dio,
    required this.navigatorKey,
  });
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final (_, rt) = await authService.getTokens();
      if (rt != null) {
        try {
          await authService.refreshJWTRT(rt);
          final (newJwt, _) = await authService.getTokens();

          if (newJwt != null) {
            final response = await dio.request(
              err.requestOptions.path,
              data: err.requestOptions.data,
              options: Options(
                method: err.requestOptions.method,
                headers: {
                  ...err.requestOptions.headers,
                  'Authorization': 'Bearer $newJwt',
                },
              ),
            );
            return handler.resolve(response);
          }
        } catch (e) {
          await authService.clearTokens();
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) {
                return AuthScreen();
              },
            ),
            (route) => false,
          );
        }
      }
      handler.next(err);
    }

    handler.next(err);
  }
}
