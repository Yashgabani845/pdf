import 'package:flutter/material.dart';
import '../managers/favourites_manager.dart';
import '../screens/author_details_page.dart';

class RecentReadItem extends StatefulWidget {
  final String title;
  final String author;
  final String description;
  final String pdfUrl;
  final String authorDescription;  // New property
  final String authorImageUrl;     // New property

  const RecentReadItem({
    required this.title,
    required this.author,
    required this.description,
    required this.pdfUrl,
    required this.authorDescription,  // Initialize new property
    required this.authorImageUrl,     // Initialize new property
  });

  @override
  _RecentReadItemState createState() => _RecentReadItemState();
}

class _RecentReadItemState extends State<RecentReadItem> {
  bool _isExpanded = false;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    // Check if the book is a favorite
    _isFavorite = FavoritesManager().isFavorite(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthorDetailsPage(
                    author: widget.author,
                    profileImagePath: widget.authorImageUrl, // Use dynamic image URL
                    authorDescription: widget.authorDescription, // Pass author description
                  ),
                ),
              );
            },
            child: Text(widget.author, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                color: _isFavorite ? Colors.red : null,
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                    if (_isFavorite) {
                      FavoritesManager().addFavorite(widget.title, widget.pdfUrl); // Provide both arguments
                    } else {
                      FavoritesManager().removeFavorite(widget.title);
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(widget.description),
          ),
      ],
    );
  }
}
