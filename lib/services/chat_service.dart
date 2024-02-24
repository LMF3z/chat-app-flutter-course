import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/services/index.dart';
import 'package:chat_app/models/index.dart';
import 'package:chat_app/global/environment.dart';

class ChatService with ChangeNotifier {
  UserModel? userTo;
  bool _isLoading = false;
  // List<Message> chatMessagesList = [];

  bool get isLoading => _isLoading;

  set toggleIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<List<Message>> getMessagesChat(String userId) async {
    try {
      final token = await AuthService.getToken();

      Uri url = Uri.parse('${Environment.apiUrl}/messages/$userId');

      toggleIsLoading = true;

      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      toggleIsLoading = false;

      if (res.statusCode == 200) {
        final messageResponse = MessageResponse.fromJson(jsonDecode(res.body));
        return messageResponse.data;
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
