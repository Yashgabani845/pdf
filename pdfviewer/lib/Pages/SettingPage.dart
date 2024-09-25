import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import 'userProfilePage.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = true;

  void logout(BuildContext context) async {
    final auth = AuthService();
    await auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: isDarkMode ? Colors.blue[900] : Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.green),
              title: Text('Profile Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              trailing: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : Colors.black),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
              },
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.dark_mode, color: Colors.green),
              title: Text('Dark Mode', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              trailing: Switch(
                value: isDarkMode,
                activeColor: Colors.blue,
                onChanged: toggleDarkMode,
              ),
            ),
            Divider(color: Colors.grey),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
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
