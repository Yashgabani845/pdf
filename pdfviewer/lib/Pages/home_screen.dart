import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/pdf_viewer_page.dart'; // Import your PDF Viewer Page
import '../Services/auth_service.dart';
import 'favorites_page.dart';
import 'SettingPage.dart';

import 'favourite_manager.dart';
import 'userProfilePage.dart';
import 'pdf_viewer_page.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> pdfAssetsFuture;
  List<Map<String, dynamic>> allPdfs = [];
  List<Map<String, dynamic>> displayedPdfs = [];
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    pdfAssetsFuture = fetchPdfAssets();
  }
  Future<List<Map<String, dynamic>>> fetchPdfAssets() async {
    try {
      List<Map<String, dynamic>> pdfData = [];
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('books').get();
      for (var doc in snapshot.docs) {
        Map<String, dynamic> pdfDataMap = doc.data() as Map<String, dynamic>;
        pdfData.add(pdfDataMap);
      }
      return pdfData;
    } catch (e) {
      print('Error loading PDFs: $e');
      return [];
    }
  }

  void addToFavorites(Map<String, dynamic> pdf) {
    FavoritesManager().addFavorite(pdf);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pdf['title'] ?? 'PDF'} added to favorites!')),
    );
  }

  void updateDisplayedPdfs() {
    setState(() {
      displayedPdfs = allPdfs.where((pdf) {
        final title = pdf['title'] ?? '';
        return title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
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
        future: pdfAssetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No PDFs found.', style: TextStyle(color: Colors.white)));
          }

          allPdfs = snapshot.data!;
          displayedPdfs = allPdfs.sublist(3);
          if (searchQuery.isNotEmpty) {
            displayedPdfs = displayedPdfs.where((pdf) {
              final title = pdf['title'] ?? '';
              return title.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      updateDisplayedPdfs();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by title...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: displayedPdfs.length,
                    itemBuilder: (context, index) {
                      var pdf = displayedPdfs[index];
                      var pdfTitle = pdf['title'] ?? 'Unknown Title';
                      var description = pdf['description'] ?? 'No description available.';
                      var pdfUrl = pdf['pdfUrl'] ?? '';
                      var imgUrl = 'sub_assets/pdf.png';

                      return GestureDetector(
                        onTap: () {
                          if (pdfUrl.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFViewerPage(pdfPath: pdfUrl),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No PDF URL available for this PDF.')),
                            );
                          }
                        },
                        child: Container(
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
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12.0),
                                  image: DecorationImage(
                                    image: AssetImage(imgUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                pdfTitle,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.favorite, color: Colors.red),
                                    onPressed: () => addToFavorites(pdf),
                                    tooltip: 'Add to Favorites',
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (pdfUrl.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFViewerPage(pdfPath: pdfUrl),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('No PDF URL available for this PDF.')),
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.visibility),
                                    label: Text('View PDF'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
            default:
              break;
          }
        },
      ),
    );
  }
}
