import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Services/auth_service.dart';
import 'package:flutter_application_1/screens/loginPage.dart';
import '../Models/User.dart';
import '../Services/userServices.dart';
import 'home_screen.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController(); // DOB Controller

  String? _selectedGender; // Gender Selection
  bool _obscurePassword = true; // Password visibility toggle
  bool _obscureConfirmPassword = true; // Confirm Password visibility toggle

  void register(BuildContext context) async {
    final auth = AuthService();
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        UserCredential userCredential = await auth.signUpWithEmailPassword(
            _emailController.text, _passwordController.text);

        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          name: _userNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          dob: _dobController.text,
          gender: _selectedGender,
        );

        createUser(user);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()), // Display the error message
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Password and Confirm Password do not match"),
        ),
      );
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(value)) {
      return 'Password must be alphanumeric (letters and numbers)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.grey[850], // Dark background for the card
                      elevation: 12.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Increased border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'PDFViewer',
                              style: TextStyle(
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent, // Lighter blue for title
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Create Your Account',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70, // Light text for description
                              ),
                            ),
                            SizedBox(height: 25),

                            // Name Field
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _userNameController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.account_circle, color: Colors.lightBlueAccent),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),

                                  // Email Field
                                  TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Email Address',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.email_outlined, color: Colors.lightBlueAccent),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                                      ),
                                    ),
                                    validator: emailValidator,
                                  ),
                                  SizedBox(height: 16),

                                  // Password Field
                                  TextFormField(
                                    controller: _passwordController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.lock_outline, color: Colors.lightBlueAccent),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                          color: Colors.white70,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: _obscurePassword,
                                    validator: passwordValidator,
                                  ),
                                  SizedBox(height: 16),

                                  // Confirm Password Field
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.lock_outline, color: Colors.lightBlueAccent),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                          color: Colors.white70,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureConfirmPassword = !_obscureConfirmPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: _obscureConfirmPassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      } else if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),

                                  // Gender Field
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Gender',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.person_outline, color: Colors.lightBlueAccent),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                    dropdownColor: Colors.grey[850],
                                    value: _selectedGender,
                                    items: ['Male', 'Female', 'Other'].map((String gender) {
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Text(gender),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedGender = newValue;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select your gender';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),

                                  // DOB Field
                                  TextFormField(
                                    controller: _dobController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Date of Birth',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.cake_outlined, color: Colors.lightBlueAccent),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                                      ),
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _dobController.text =
                                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Date of Birth';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 30),

                                  // Signup Button
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        register(context);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      minimumSize: Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      backgroundColor: Colors.lightBlueAccent,
                                    ),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  // Login Option
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account?',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => SignInPage()),
                                          );
                                        },
                                        child: Text(
                                          'Log in',
                                          style: TextStyle(color: Colors.lightBlueAccent),
                                        ),
                                      ),
                                    ],
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
            ),
          );
        },
      ),
    );
  }
}
