import 'dart:async';
import 'package:chattify/Screens/Login/Mobile/login.Mobile.dart';
import 'package:chattify/Utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      Get.to(() => const LoginViewM());
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/chat.gif',
              height: 150,
              width: 150,
            ),
            Text(
              'Chattify',
              style: TextStyle(
                color: GlobalColors.textColor1,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
