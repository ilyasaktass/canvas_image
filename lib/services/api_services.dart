import 'dart:convert';
import 'package:canvas_image/models/books.dart';
import 'package:canvas_image/models/classes.dart';
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
    await prefs.clear(); // Tüm bilgileri temizle
  }

  static Future<Classes?> getClasses() async {
    final prefs = await SharedPreferences.getInstance();
    String? token;
    final userJson = prefs.getString('user');

    if (userJson != null) {
      User user = User.fromJson(jsonDecode(userJson));
      if (user.accessToken.isNotEmpty) {
        token = user.accessToken;
      }
    }

    if (token == null) {
      EasyLoading.showError('Token bulunamadı, lütfen tekrar giriş yapın.');
      return null;
    }

    final result = await requestHandler(
      request: () => http.get(
        Uri.parse('$_baseUrl/MobileSolution/GetAppClasses'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      ),
      loadingMessage: 'Sınıflar yükleniyor...',
    );

    if (result['success']) {
      return Classes.fromJson(result['data']);
    } else {
      EasyLoading.showError(result['error']);
      return null;
    }
  }

  static Future<Books?> getBooks(int classId, bool showUserFavoriteBooks) async {
    final prefs = await SharedPreferences.getInstance();
    String? token;
    final userJson = prefs.getString('user');

    if (userJson != null) {
      User user = User.fromJson(jsonDecode(userJson));
      if (user.accessToken.isNotEmpty) {
        token = user.accessToken;
      }
    }

    if (token == null) {
      EasyLoading.showError('Token bulunamadı, lütfen tekrar giriş yapın.');
      return null;
    }

    final result = await requestHandler(
      request: () => http.get(
        Uri.parse('$_baseUrl/MobileSolution/GetBooks?classId=$classId&showUserFavoriteBooks=$showUserFavoriteBooks'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      ),
      loadingMessage: 'Kitaplar yükleniyor...',
    );

    if (result['success']) {
      print(result);
      return Books.fromJson(result['data']);
    } else {
      EasyLoading.showError(result['error']);
      return null;
    }
  }
}
