import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import secure storage
import 'signup_dart.dart'; // Import SignupPage
import 'home_screen.dart';  // Or navigate to your main screen

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  // Create secure storage instance
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      var response = await http.post(
        Uri.parse('http://localhost:5000/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Log the response

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String? token = data['token'];
        String? userMessage = data['message'];

        if (token != null) {
          await secureStorage.write(key: 'token', value: token);
          await secureStorage.write(key: 'userName', value: data['userName']); // Store user name
          await secureStorage.write(key: 'userEmail', value: email); // Store email

          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Invalid credentials. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
      print('Error during login: ${e.toString()}'); // Log error for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: loginUser,
              child: Text('Login'),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
