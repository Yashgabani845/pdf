import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_screen.dart';
import 'pages/main_screen.dart';
import 'theme_provider.dart';
import 'pages/login_page.dart'; // Import your login screen
import 'auth_provider.dart'; // Import the AuthProvider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(), // Provide the AuthProvider
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: PDFViewerApp(),
      ),
    ),
  );
}

class PDFViewerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.grey,
            scaffoldBackgroundColor: Colors.black,
            fontFamily: 'Roboto',
          ),
          home: AuthenticatedHome(), // Navigate based on auth
        );
      },
    );
  }
}

class AuthenticatedHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = Provider.of<AuthProvider>(context).isAuthenticated; // Use the provider
    print("Is authenticated: $isAuthenticated"); // Debug output
    if (isAuthenticated) {
      return MainScreen(); // Show MainScreen if authenticated
    } else {
      return LoginPage(); // Show LoginScreen if not authenticated
    }
  }
}
