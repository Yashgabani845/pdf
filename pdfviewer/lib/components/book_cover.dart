import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../screens/pdf_viewer_page.dart';

class BookCover extends StatelessWidget {
  final String imagePath;
  final String pdfUrl;

  const BookCover({required this.imagePath, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(pdfPath: pdfUrl), // Pass the Firebase PDF URL for Book 1
          ),
        );
      },
      child: Container(
        width: 120.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imagePath.startsWith('http') ? NetworkImage(imagePath) : AssetImage(imagePath) as ImageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
