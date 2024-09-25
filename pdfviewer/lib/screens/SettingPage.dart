import 'package:flutter/material.dart';
import '../Services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = true; // For the dark mode toggle

  void logout(BuildContext context) async {
    final auth = AuthService();
    await auth.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login page on logout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background to black
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900], // AppBar with blue theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.green), // Profile settings icon
              title: Text('Profile Settings', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                // Navigate to Profile Settings
              },
            ),
            Divider(color: Colors.grey),

            ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue), // Notification settings icon
              title: Text('Notification Settings', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                // Navigate to Notification Settings
              },
            ),
            Divider(color: Colors.grey),

            ListTile(
              leading: Icon(Icons.dark_mode, color: Colors.green), // Dark mode toggle
              title: Text('Dark Mode', style: TextStyle(color: Colors.white)),
              trailing: Switch(
                value: isDarkMode,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value; // Toggle dark mode
                  });
                },
              ),
            ),
            Divider(color: Colors.grey),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.red), // Logout icon
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                logout(context); // Trigger logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
