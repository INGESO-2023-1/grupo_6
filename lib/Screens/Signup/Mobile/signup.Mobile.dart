import 'package:chattify/Screens/Home/Chat.screen.dart';
import 'package:chattify/Screens/Login/Mobile/login.Mobile.dart';
import 'package:chattify/Utils/global_colors.dart';
import 'package:chattify/Utils/social.dart';
import 'package:chattify/Utils/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Center(
              child: SvgPicture.asset(
                'assets/images/chat.svg',
                height: MediaQuery.of(context).size.height * 0.12,
                //height 100 y width 100
                width: MediaQuery.of(context).size.height * 0.12,
              ),
            ),
            const SizedBox(height: 1),
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
              'Create to your Account',
              style: TextStyle(
                  color: GlobalColors.textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.035),
            reusableTextField("Full Name", Icons.person_outline, false,
                _userNameTextController),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            reusableTextField("Email", Icons.mail, false, _emailTextController),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            reusableTextField(
                "Password", Icons.lock_outlined, true, _passwordTextController),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            firebaseUIButton(context, "Sign Up", () {
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                  .then((value) {
                print("Created New Account");
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
            signInOption()
          ],
        ),
      )),
    );
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?",
            style: TextStyle(color: Color.fromARGB(179, 0, 0, 0))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginViewM()));
          },
          child: Text(
            " Sign in",
            style: TextStyle(
                color: GlobalColors.textColor1, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
