import 'package:chattify/Screens/Home/Chat.screen.dart';
import 'package:chattify/Screens/Signup/Mobile/signup.Mobile.dart';
import 'package:chattify/Utils/global_colors.dart';
import 'package:chattify/Utils/social.dart';
import 'package:chattify/Utils/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginViewM extends StatefulWidget {
  const LoginViewM({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<LoginViewM> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    //height: 45),
                    height: MediaQuery.of(context).size.height * 0.06),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/chat.svg',
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  alignment: Alignment.center,
                  child: Text('Chattify',
                      style: TextStyle(
                          color: GlobalColors.textColor1,
                          fontFamily: 'Poppins',
                          fontSize: 35,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Text(
                  'Login to your Account',
                  style: TextStyle(
                      color: GlobalColors.textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                reusableTextField(
                    "Email", Icons.email, false, _emailTextController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                reusableTextField("Password", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                firebaseUIButton(context, "Sign In", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                const SocialLogin(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Color.fromARGB(179, 0, 0, 0))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: Text(
            " Sign Up",
            style: TextStyle(
                color: GlobalColors.textColor1, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
