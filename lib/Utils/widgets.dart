import 'package:chattify/Utils/global_colors.dart';
import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: const Color.fromARGB(255, 215, 104, 237),
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color.fromARGB(255, 215, 104, 237),
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
      //filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      //fillColor: Colors.black.withOpacity(0.3),
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(color: Color.fromARGB(255, 231, 192, 232))),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(color: Color.fromARGB(255, 193, 144, 203))),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color.fromARGB(255, 215, 104, 237);
            }
            return GlobalColors.textColor1;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}
