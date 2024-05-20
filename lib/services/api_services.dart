import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ApiService {
  static const String _baseUrl = 'https://advdijital.com/api';

  static Future<Map<String, dynamic>> requestHandler({
    required Future<http.Response> Function() request,
    required String loadingMessage,
    String successMessage = '',
  }) async {
    try {
      EasyLoading.show(status: loadingMessage);

      final response = await request();

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        if (successMessage.isNotEmpty) {
          EasyLoading.showSuccess(successMessage);
        }
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final error = jsonDecode(response.body)['error'];
        EasyLoading.dismiss();
        EasyLoading.showError(error);
        return {'success': false, 'error': error};
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Bir hata oluştu: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    return await requestHandler(
      request: () => http.post(
        Uri.parse('$_baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'password',
          'username': email,
          'password': password,
          'remember': 'true',
        },
      ),
      loadingMessage: 'Giriş yapılıyor...',
      successMessage: 'Giriş başarılı',
    );
  }

  static Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    return await requestHandler(
      request: () => http.get(
        Uri.parse('$_baseUrl/user/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      loadingMessage: 'Profil yükleniyor...',
    );
  }
}
