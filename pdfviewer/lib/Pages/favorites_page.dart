import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'favourite_manager.dart';
import 'pdf_viewer_page.dart';
class FavoritesPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Favorites')),
        body: Center(child: Text('You need to be logged in to view your favorites.')),
      );
    }

    final String userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        color: Colors.black,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').doc(userId).collection('favorites').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No favorites yet.', style: TextStyle(color: Colors.white)));
            }

            final favoriteBooks = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: favoriteBooks.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic>? book = favoriteBooks[index].data() as Map<String, dynamic>?;

                  if (book == null) {
                    return Container();
                  }

                  final String title = book['title'] ?? 'No Title';
                  final String pdfUrl = book['pdfUrl'] ?? '';
                  final String bookId = favoriteBooks[index].id;

                  return GestureDetector(
                    onTap: () {
                      if (pdfUrl.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PDFViewerPage(pdfPath: pdfUrl)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No PDF URL available for this book.')),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[700]!, Colors.purple[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.picture_as_pdf, size: 70, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            title,
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await FavoritesManager().removeFavorite(bookId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$title removed from favorites.')),
                              );
                            },
                            child: Text('Remove'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
