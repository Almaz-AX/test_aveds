import 'package:aveds_test/features/auth/auth_interceptor.dart';
import 'package:aveds_test/main_app.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio dio;
  final SharedPreferences prefs;
  static const _jwtKey = 'jwt_token';
  static const _rtKey = 'refresh_token';

  AuthService({required this.dio, required this.prefs}){
    dio.interceptors.add(AuthInterceptor(authService: this, dio: dio, navigatorKey: navigatorKey));
  }

  Future<void> saveTokens(String jwt, String rt) async {
    await prefs.setString(_jwtKey, jwt);
    await prefs.setString(_rtKey, rt);
  }

  Future<(String?, String?)> getTokens() async {
    return (prefs.getString(_jwtKey), prefs.getString(_rtKey));
  }

  Future<void> clearTokens() async {
    await prefs.remove(_jwtKey);
    await prefs.remove(_rtKey);
  }

  Future<void> sendCodeToEmail(String email) async {
    await dio.post(
      "https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net/login",
      data: {"email": email},
    );
  }

  Future<void> getJWTRT(String email, int code) async {
    final response = await dio.post(
      'https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net/confirm_code',
      data: {"email": email, "code": code},
    );
    await saveTokens(
      response.data["jwt"] as String,
      response.data["refresh_token"],
    );
  }

  Future<void> refreshJWTRT(String rt) async {
    final response = await dio.post(
      'https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net/refresh_token',
      data: {"token": rt},
    );
    await prefs.setString(_jwtKey, response.data["refresh_token"]);
  }

  Future<String> getUserid(String jwt) async {
    final response = await dio.get(
      'https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net/auth',
      options: Options(headers: {'Auth': 'Bearer $jwt'}),
    );
    return response.data['user_id'] as String;
  }
}
