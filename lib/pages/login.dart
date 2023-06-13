import 'package:chattify/pages/admin.dart';
import 'package:chattify/pages/root.dart';
import 'package:chattify/services/auth.dart';
import 'package:chattify/theme/gcolors.dart';
import 'package:chattify/widgets/custom_dialog.dart';
import 'package:chattify/widgets/custom_textfield.dart';
import 'package:chattify/widgets/social.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscureText = true;
  AuthService service = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: getBody(),
      floatingActionButton:
          Visibility(visible: !keyboardIsOpen, child: getNavigationButton()),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  getBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
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
            Center(
              child: Text(
                "Login to your Account",
                style: TextStyle(
                    color: GlobalColors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            CustomTextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              leadingIcon: const Icon(
                Icons.email_outlined,
                color: Colors.grey,
              ),
              hintText: "Email",
            ),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: passwordController,
              leadingIcon: const Icon(
                Icons.lock_outline,
                color: Colors.grey,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                child: Icon(
                    isObscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey),
              ),
              obscureText: isObscureText,
              hintText: "Password",
            ),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundedLoadingButton(
                    width: MediaQuery.of(context).size.width,
                    color: GlobalColors.textColor1,
                    controller: btnController,
                    onPressed: () async {
                      if (emailController.text == 'admin@usm.cl' &&
                          passwordController.text == 'administrador1') {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const AdminPage()),
                          (route) => false,
                        );
                      } else {
                        FocusScope.of(context).unfocus();
                        var res = await service.signInWithEmailPassword(
                            emailController.text, passwordController.text);
                        if (res["status"] == false) {
                          btnController.reset();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: "Login",
                                  descriptions: res["message"],
                                );
                              });
                        } else {
                          btnController.success();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const RootApp()),
                              (route) => false);
                        }
                      }
                    },
                    child: const Text("Sign In",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SocialLogin(),
          ],
        ),
      ),
    );
  }

  Widget getNavigationButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Color.fromARGB(179, 0, 0, 0))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
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
