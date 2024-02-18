import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/index.dart';
import 'package:chat_app/models/index.dart';

class UsersService {
  Future<List<UserModel>> getUsers() async {
    try {
      final token = await AuthService.getToken();

      Uri url = Uri.parse('${Environment.apiUrl}/users?skip=${0}');

      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (res.statusCode == 200) {
        final resData = UsersResponse.fromJson(jsonDecode(res.body));
        return resData.data;
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
