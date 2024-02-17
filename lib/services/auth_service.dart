import 'dart:convert';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/register_response_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/global/environment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  UserModel? userAuth;
  bool _isLoading = false;

  final _storage = FlutterSecureStorage();

  bool get isLoading => _isLoading;

  set toggleIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // getters setters token
  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token ?? '';
  }

  static Future deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    toggleIsLoading = true;

    final data = {'email': email, 'password': password};

    Uri url = Uri.parse('${Environment.apiUrl}/auth/login');

    final res = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    toggleIsLoading = false;

    if (res.statusCode == 200) {
      final loginRes = LoginResponse.fromJson(jsonDecode(res.body));
      userAuth = loginRes.data.user;
      await _saveTokenSession(loginRes.data.token);
      return true;
    }

    return false;
  }

  Future<bool> renewToken(String token) async {
    toggleIsLoading = true;

    Uri url = Uri.parse('${Environment.apiUrl}/auth/renew');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'x-token': token},
    );

    toggleIsLoading = false;

    if (res.statusCode == 200) {
      final loginRes = LoginResponse.fromJson(jsonDecode(res.body));
      userAuth = loginRes.data.user;
      await _saveTokenSession(loginRes.data.token);
      return true;
    }

    await logout();

    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    toggleIsLoading = true;

    final data = {'name': name, 'email': email, 'password': password};

    Uri url = Uri.parse('${Environment.apiUrl}/auth/new');

    final res = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    toggleIsLoading = false;

    if (res.statusCode == 200) {
      RegisterResponse.fromJson(jsonDecode(res.body));
      return true;
    }

    return false;
  }

  Future _saveTokenSession(String token) async {
    await _storage.write(key: 'token', value: token);
    return;
  }

  Future logout() async {
    await _storage.delete(key: 'token');
    return;
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final newToken = await renewToken(token ?? '');
    return newToken;
  }
}
