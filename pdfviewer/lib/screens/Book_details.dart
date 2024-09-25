import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display book cover image
            Image.network(
              book['imgUrl'] ?? 'assets/sub_assets/placeholder.jpg',
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            // Display book title
            Text(
              book['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // Display author details
            Text(
              'Author: ${book['authorDetails']['name'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16.0),
            // Display book description or other details
            Text(
              'Description: ${book['description'] ?? 'No description available.'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            // Button to read/download the book
            ElevatedButton(
              onPressed: () {
                // Add functionality to read/download the book
                // For example, you could use the pdfUrl to open the PDF reader
              },
              child: Text('Read Book'),
            ),
          ],
        ),
      ),
    );
  }
}
