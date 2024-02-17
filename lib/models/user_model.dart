// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UserModel usersModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String usersModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? name;
  String? email;
  bool? online;
  String? uuid;

  UserModel({
    this.name,
    this.email,
    this.online,
    this.uuid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
        online: json["online"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "online": online,
        "uuid": uuid,
      };
}
