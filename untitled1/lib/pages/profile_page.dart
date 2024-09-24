import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import secure storage
import 'login_page.dart'; // Import the LoginPage for navigation

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  String? userEmail;

  // Create secure storage instance
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userName = await secureStorage.read(key: 'userName');
    userEmail = await secureStorage.read(key: 'userEmail');
    setState(() {});
  }

  Future<void> _logout() async {
    await secureStorage.deleteAll(); // Clear all secure storage data

    // Redirect to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/sample1.png'), // Ensure correct asset path
              ),
            ),
            SizedBox(height: 20),
            // User Name
            Center(
              child: Text(
                'Name: ${userName ?? 'Loading...'}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            // User Email
            Center(
              child: Text(
                'Email: ${userEmail ?? 'Loading...'}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Divider
            Divider(color: Colors.grey[700]),
            SizedBox(height: 20),
            // PDF Collection Button
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(
                'My PDF Collection',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to PDF collection page
              },
            ),
            // Settings Button
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Settings page
              },
            ),
            // Logout Button
            ListTile(
              leading: Icon(Icons.logout, color: Colors.orange),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
