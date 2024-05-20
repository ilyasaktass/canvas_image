import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:canvas_image/models/user.dart';

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
    final result = await requestHandler(
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

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      User user = User.fromJson(result['data']);
      await prefs.setString('user', jsonEncode(user.toJson()));
    }

    return result;
  }

  static Future<User?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Tüm bilgileri temizle
  }
}
