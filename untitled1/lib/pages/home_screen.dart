import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> pdfs = [
    {
      'name': 'Sample PDF 1',
      'path': 'assets/sample1.pdf',
      'details': '200 KB',
    },
    {
      'name': 'Sample PDF 2',
      'path': 'assets/sample2.pdf',
      'details': '500 KB',
    },
    {
      'name': 'Sample PDF 3',
      'path': 'assets/sample3.pdf',
      'details': '300 KB',
    },
  ];

  List<Map<String, String>> filteredPdfs = [];
  List<Map<String, String>> favoritePdfs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPdfs = pdfs;
    _searchController.addListener(() {
      _filterPdfs();
    });
  }

  void _filterPdfs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPdfs = pdfs
          .where((pdf) => pdf['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleFavorite(Map<String, String> pdf) {
    setState(() {
      if (favoritePdfs.contains(pdf)) {
        favoritePdfs.remove(pdf);
      } else {
        favoritePdfs.add(pdf);
      }
    });
  }

  void _removeFavorite(Map<String, String> pdf) {
    setState(() {
      favoritePdfs.remove(pdf);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PDF Viewer'),
          backgroundColor: Colors.grey[900],
          bottom: TabBar(
            tabs: [
              Tab(text: 'All PDFs'),
              Tab(text: 'Favorites'),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: 200,
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search PDFs',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // All PDFs Tab
            GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: filteredPdfs.length,
              itemBuilder: (context, index) {
                final pdf = filteredPdfs[index];
                final isFavorite = favoritePdfs.contains(pdf);
                return Card(
                  color: Colors.grey[800],
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFViewerPage(path: pdf['path']!),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(Icons.picture_as_pdf, size: 100, color: Colors.white),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.white,
                                  ),
                                  onPressed: () => _toggleFavorite(pdf),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                pdf['name']!,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                pdf['details']!,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Favorites Tab
            GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: favoritePdfs.length,
              itemBuilder: (context, index) {
                final pdf = favoritePdfs[index];
                return Card(
                  color: Colors.grey[800],
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFViewerPage(path: pdf['path']!),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(Icons.picture_as_pdf, size: 100, color: Colors.white),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeFavorite(pdf),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                pdf['name']!,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                pdf['details']!,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final String path;

  PDFViewerPage({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: Colors.grey[900],
      ),
      body: PDFView(
        filePath: path,
      ),
    );
  }
}
