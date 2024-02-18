import 'dart:convert';

import 'package:chat_app/models/user_model.dart';

UsersResponse usersResponseFromJson(String str) =>
    UsersResponse.fromJson(json.decode(str));

String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
  String message;
  List<UserModel> data;

  UsersResponse({
    required this.message,
    required this.data,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        message: json["message"],
        data: List<UserModel>.from(
            json["data"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
