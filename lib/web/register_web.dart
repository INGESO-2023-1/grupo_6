import 'package:chattify/pages/root.dart';
import 'package:chattify/services/auth.dart';
import 'package:chattify/theme/gcolors.dart';
import 'package:chattify/web/login_web.dart';
import 'package:chattify/widgets/custom_dialog.dart';
import 'package:chattify/widgets/custom_textfield.dart';
import 'package:chattify/widgets/social.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterWeb extends StatelessWidget {
  const RegisterWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chattify',
      home: RegisterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: const [
          Menu(),
          // MediaQuery.of(context).size.width >= 980
          //     ? Menu()
          //     : SizedBox(), // Responsive
          Body()
        ],
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginWeb()));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 75),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      'Home',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              _menuItem(title: 'About us'),
              _menuItem(title: 'Contact us'),
              _menuItem(title: 'Help'),
            ],
          ),
          Row(
            children: [
              _registerButton(),
              const SizedBox(
                width: 70,
              ),
              _menuItem(title: 'Register', isActive: true)
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 75),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? GlobalColors.textColor1 : Colors.grey,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            isActive
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            spreadRadius: 10,
            blurRadius: 12,
          ),
        ],
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<Body> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 360,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign Up to \nChattify',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'images/illustration-2.png',
                width: 300,
              ),
            ],
          ),
        ),

        Image.asset(
          'images/illustration-1.png',
          width: 300,
        ),
        // MediaQuery.of(context).size.width >= 1300 //Responsive
        //     ? Image.asset(
        //         'images/illustration-1.png',
        //         width: 300,
        //       )
        //     : SizedBox(),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 6),
          child: SizedBox(
            width: 320,
            child: Column(
              children: [
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SocialLogin(),
              ],
            ),
          ),
        )
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
