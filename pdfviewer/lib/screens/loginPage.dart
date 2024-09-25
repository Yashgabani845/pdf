import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/auth_service.dart';
import 'home_screen.dart';
import 'signupPage.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _authFormKey = GlobalKey<FormState>();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  bool _showPassword = false;
  String? _loginError;

  void attemptLogin(BuildContext context) async {
    final authService = AuthService();

    final userEmail = _userEmailController.text;
    final userPassword = _userPasswordController.text;

    try {
      if (!_isValidEmail(userEmail)) {
        _displayErrorDialog(context, 'Invalid email format. Please enter a valid email.');
        return;
      }

      if (userPassword.length < 6) {
        _displayErrorDialog(context, 'Password must be at least 6 characters.');
        return;
      }

      await authService.signInWithEmailPassword(userEmail, userPassword);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

    } catch (e) {
      _displayErrorDialog(context, e.toString());
    }
  }

  void _displayErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailPattern = RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+");
    return emailPattern.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center( // Centering the entire login block
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 12.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'PDF Viewer',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono', // Change to your preferred font family
                        color: Colors.blue[300],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey[200],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please sign in to continue',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blueGrey[400],
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _authFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _userEmailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: Colors.blue[200]),
                              filled: true,
                              fillColor: Colors.grey[850],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(Icons.email, color: Colors.blue[300]),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!_isValidEmail(value)) {
                                return 'Invalid email format';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _userPasswordController,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.blue[200]),
                              filled: true,
                              fillColor: Colors.grey[850],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(Icons.lock, color: Colors.blue[300]),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.blue[300],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be 6+ characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_authFormKey.currentState!.validate()) {
                                attemptLogin(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text('Sign In Now'),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupPage()),
                              );
                            },
                            child: Text(
                              'Create a new account',
                              style: TextStyle(
                                color: Colors.blue[300],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
