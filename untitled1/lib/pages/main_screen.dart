import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'setting_page.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of pages corresponding to the bottom navigation bar
  final List<Widget> _pages = [
    HomeScreen(),
    SettingsPage(),
    ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blueAccent,
        currentIndex: _currentIndex,
        onTap: onTabTapped, // Handle tab taps
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
