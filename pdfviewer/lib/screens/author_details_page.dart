import 'package:flutter/material.dart';

class AuthorDetailsPage extends StatelessWidget {
  final String author;
  final String profileImagePath;
  final String authorDescription; // Add description property

  const AuthorDetailsPage({
    required this.author,
    required this.profileImagePath,
    required this.authorDescription, // Initialize it
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Author Details'),
        backgroundColor: Colors.blueGrey[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: profileImagePath.isNotEmpty
                  ? NetworkImage(profileImagePath)
                  : AssetImage('assets/sub_assets/placeholder.jpg') as ImageProvider,
            ),
            SizedBox(height: 16.0),
            Text(
              author,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              authorDescription,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
