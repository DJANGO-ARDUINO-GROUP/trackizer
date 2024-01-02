import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackizer/screens/home_screen.dart';
import 'package:trackizer/screens/sign_up_screen.dart';
import 'package:trackizer/secure_storage.dart';

void main() async {
  runApp(const MyApp());
}

final SecureStorage secureStorage = SecureStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: secureStorage.readSecureData("auth_token"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            print(data);
            return const HomeScreen();
          }
          return const SignUpScreen();
        },
      ),
      // secureStorage.readSecureData("auth_token") == null ? SignUpScreen() :
      // MyHomePage(),
    );
  }
}
