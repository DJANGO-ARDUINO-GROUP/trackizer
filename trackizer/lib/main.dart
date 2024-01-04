import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackizer/screens/home_screen.dart';
import 'package:trackizer/screens/sign_up_screen.dart';
import 'package:trackizer/secure_storage.dart';

void main() async {
  final runnableApp = _buildRunnableApp(
    isWeb: kIsWeb,
    webAppWidth: 450.0,
    app: const MyApp(),
  );

  runApp(runnableApp);
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Container(
    color: Colors.grey.shade900,
    child: Center(
      child: ClipRect(
        child: SizedBox(
          width: webAppWidth,
          child: app,
        ),
      ),
    ),
  );
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
