import 'package:chattify/firebase_options.dart';
import 'package:chattify/pages/root.dart';
import 'package:chattify/theme/gcolors.dart';
import 'package:chattify/web/login_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.createUserWithEmailAndPassword(
      email: 'admin@usm.cl',
      password: 'administrador1',
    );
    print('Usuario "admin@usm.cl" creado correctamente.');
  } catch (e) {
    print('Error al crear el usuario: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chattify',
        theme: ThemeData(
          primaryColor: GlobalColors.textColor1,
        ),
        home: kIsWeb ? const LoginWeb() : const RootApp());
  }
}
