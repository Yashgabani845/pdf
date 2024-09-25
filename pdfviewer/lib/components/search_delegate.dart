import 'package:flutter/material.dart';
import '../components/recent_read_item.dart';
import '../screens/pdf_viewer_page.dart';

class BookSearchDelegate extends SearchDelegate {
  final List<RecentReadItem> recentBooks;

  BookSearchDelegate(this.recentBooks);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context); // To refresh suggestions when the query is cleared
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // If the query is empty, return an empty container
    if (query.isEmpty) {
      return Center(
        child: Text("Start typing to search for books"),
      );
    }

    // Filter books based on the search query
    final results = recentBooks.where((book) => book.title.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results.map((book) {
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            // Navigate to PDFViewerPage and pass the PDF URL of the selected book
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFViewerPage(pdfPath: book.pdfUrl), // Pass the PDF URL
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // If the query is empty, show an empty container or a helpful message
    if (query.isEmpty) {
      return Center(
        child: Text("Start typing to search for books"),
      );
    }

    // Display suggestions based on the search query
    final suggestions = recentBooks.where((book) => book.title.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: suggestions.map((book) {
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            query = book.title;
            // Show the results immediately when a suggestion is tapped
            showResults(context);
          },
        );
      }).toList(),
    );
  }
}
