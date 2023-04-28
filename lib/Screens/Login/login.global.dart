import 'package:chattify/Screens/Login/Mobile/login.Mobile.dart';
import 'package:chattify/Screens/Login/Web/login.Web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: kIsWeb ? LoginViewW() : LoginViewM(),
    );
  }
}
