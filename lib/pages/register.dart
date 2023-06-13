import 'package:chattify/pages/root.dart';
import 'package:chattify/services/auth.dart';
import 'package:chattify/theme/gcolors.dart';
import 'package:chattify/widgets/custom_dialog.dart';
import 'package:chattify/widgets/custom_textfield.dart';
import 'package:chattify/widgets/social.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hidedPwd = true;
  bool hidenConPwd = true;
  AuthService service = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confrimPasswordController =
      TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: getBody(context),
      floatingActionButton:
          Visibility(visible: !keyboardIsOpen, child: getNavigationButton()),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  getBody(context) {
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Center(
              child: Text(
                "Register to your Account",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: GlobalColors.textColor),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomTextField(
              controller: nameController,
              leadingIcon: const Icon(
                Icons.person_outline,
                color: Colors.grey,
              ),
              hintText: "Name",
            ),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: passwordController,
              leadingIcon: const Icon(
                Icons.lock_outline,
                color: Colors.grey,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    hidedPwd = !hidedPwd;
                  });
                },
                child: Icon(
                    hidedPwd
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey),
              ),
              obscureText: hidedPwd,
              hintText: "Password",
            ),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: confrimPasswordController,
              leadingIcon: const Icon(
                Icons.lock_outline,
                color: Colors.grey,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    hidenConPwd = !hidenConPwd;
                  });
                },
                child: Icon(
                    hidenConPwd
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey),
              ),
              obscureText: hidenConPwd,
              hintText: "Confirm Password",
            ),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundedLoadingButton(
                    width: MediaQuery.of(context).size.width,
                    color: GlobalColors.textColor1,
                    controller: btnController,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      registerProceed();
                    },
                    child: const Text("Sign Up",
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
        const Text(
          "Already have an account?",
          style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Text(
            " Sign in",
            style: TextStyle(
              color: GlobalColors.textColor1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  registerProceed() async {
    if (passwordController.text != confrimPasswordController.text) {
      btnController.reset();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomDialogBox(
              descriptions: "Password and Confirm Password are not matched.",
            );
          });
      return;
    }

    var res = await service.registerWithEmailPassword(
        nameController.text, emailController.text, passwordController.text);
    if (res["status"] == false) {
      btnController.reset();
      print("Failed");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Register",
              descriptions: res["message"],
            );
          });
    } else {
      btnController.success();
      print("Success");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const RootApp()),
          (route) => false);
    }
  }
}
