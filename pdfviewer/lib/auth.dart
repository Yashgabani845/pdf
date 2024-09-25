import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/loginPage.dart';
import 'package:flutter_application_1/Pages/home_screen.dart';

class AuthGate extends StatelessWidget{
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          //user is loggedin
          if(snapshot.hasData){
            return  HomeScreen();
          }
          else{
            return SignInPage();
          }
        },
      )
    );
  }
}