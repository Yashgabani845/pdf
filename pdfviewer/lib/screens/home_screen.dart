import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/userProfilePage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../components/book_cover.dart';
import '../components/search_delegate.dart';
import '../Services/auth_service.dart';
import 'favorites_page.dart';
import 'SettingPage.dart';
import 'favourite_manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'favorites_page.dart'; // Import your FavoritesPage


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> bookAssetsFuture;

  @override
  void initState() {
    super.initState();
    bookAssetsFuture = fetchBookAssets();
  }

  Future<List<Map<String, dynamic>>> fetchBookAssets() async {
    try {
      List<Map<String, dynamic>> bookData = [];
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('books').get();
      for (var doc in snapshot.docs) {
        Map<String, dynamic> bookDataMap = doc.data() as Map<String, dynamic>;
        DocumentSnapshot authorDoc = await doc.reference.collection('Author').doc('author1').get();
        if (authorDoc.exists && authorDoc.data() != null) {
          bookDataMap['authorDetails'] = authorDoc.data();
        }
        bookData.add(bookDataMap);
      }
      return bookData;
    } catch (e) {
      print('Error loading books: $e');
      return [];
    }
  }

  void addToFavorites(Map<String, dynamic> book) {
    FavoritesManager().addFavorite(book);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${book['title']} added to favorites!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('PDF Viewer', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: bookAssetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books found.', style: TextStyle(color: Colors.white)));
          }

          List<Map<String, dynamic>> bookData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: bookData.length,
              itemBuilder: (context, index) {
                var book = bookData[index];
                var authorDetails = book['authorDetails'];
                var bookTitle = book['title'] ?? 'Unknown Title';
                var authorName = authorDetails != null ? authorDetails['name'] : 'Unknown Author';
                var description = book['description'] ?? 'No description available.';
                var pdfUrl = book['pdfUrl'] ?? '';
                var imgUrl = book['imgUrl'] ?? 'assets/sub_assets/placeholder.jpg';

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BookCover(
                        imagePath: imgUrl,
                        pdfUrl: pdfUrl,
                      ),
                      SizedBox(height: 8),
                      Text(
                        bookTitle,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        authorName,
                        style: TextStyle(color: Colors.grey[400]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          description,
                          style: TextStyle(color: Colors.grey[300]),
                          textAlign: TextAlign.center,
                          maxLines: 3, // Limiting to 3 lines for better layout
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => addToFavorites(book),
                        child: Text('Like'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[400],
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
              break;
          }
        },
      ),
    );
  }
}
