// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
    UserClass? user;
    String? name;
    String? balance;

    User({
        this.user,
        this.name,
        this.balance,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        user: json["user"] == null ? null : UserClass.fromJson(json["user"]),
        name: json["name"],
        balance: json["balance"],
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "name": name,
        "balance": balance,
    };
}

class UserClass {
    int? id;
    String? username;
    String? email;
    String? firstName;
    String? lastName;
    String? password;

    UserClass({
        this.id,
        this.username,
        this.email,
        this.firstName,
        this.lastName,
        this.password,
    });

    factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
    };
}
