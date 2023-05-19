import 'package:chattify/Screens/Home/Mobile/Chat.screen.dart';
import 'package:chattify/Screens/Login/Mobile/login.Mobile.dart';
import 'package:chattify/Utils/global_colors.dart';
import 'package:chattify/Utils/social.dart';
import 'package:chattify/Utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/chat.svg',
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.height * 0.12,
                  ),
                ),
                const SizedBox(height: 1),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Chattify',
                    style: TextStyle(
                      color: GlobalColors.textColor1,
                      fontFamily: 'Poppins',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Text(
                  'Create to your Account',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                reusableTextField(
                  "Full Name",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                reusableTextField(
                  "Email",
                  Icons.mail,
                  false,
                  _emailTextController,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                reusableTextField(
                  "Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                firebaseUIButton(context, "Sign Up", () {
                  createUserAndSaveData();
                }),
                const SocialLogin(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                signInOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUserAndSaveData() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        String userId = user.uid;

        // Guardar los datos del usuario en Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userId)
            .set({
          'nombre': _userNameTextController.text,
          // Agrega aquí los campos adicionales que desees almacenar
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print("Error al crear el usuario: $e");
    }
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginViewM()),
            );
          },
          child: const Text(
            " Sign in",
            style: TextStyle(
              color: Color.fromARGB(255, 229, 124, 241),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
