import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth_gate.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'screens/signupPage.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => AuthGate(),
      '/signup': (context) => SignupPage(),
      '/home': (context) => HomeScreen(),
    },
  ));
}









