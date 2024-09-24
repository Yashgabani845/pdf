import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  double _fontSize = 16.0;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Dark Mode', style: TextStyle(color: Colors.white)),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
            ListTile(
              title: Text('Notifications', style: TextStyle(color: Colors.white)),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Font Size', style: TextStyle(color: Colors.white)),
              subtitle: Slider(
                value: _fontSize,
                min: 10.0,
                max: 30.0,
                divisions: 20,
                label: _fontSize.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Language', style: TextStyle(color: Colors.white)),
              subtitle: DropdownButton<String>(
                value: _language,
                dropdownColor: Colors.grey[800],
                onChanged: (String? newValue) {
                  setState(() {
                    _language = newValue!;
                  });
                },
                items: <String>['English', 'Spanish', 'French', 'German']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[850],
    );
  }
}
