import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../Services/auth_service.dart'; // Assuming you have an AuthService to get the current user

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  // Use a ValueNotifier to track changes in favorites
  final ValueNotifier<List<Map<String, dynamic>>> favoritesNotifier =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  // Add a book to favorites in Firestore and notify listeners
  Future<void> addFavorite(String title, String pdfUrl) async {
    final currentUser = AuthService().getCurrentUser();
    if (currentUser == null) return;

    final userId = currentUser.uid;
    final favoriteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites');

    final favoriteDoc = favoriteRef.doc();
    await favoriteDoc.set({
      'title': title,
      'pdfUrl': pdfUrl,
    });

    // Update local favorites list
    favoritesNotifier.value.add({'title': title, 'pdfUrl': pdfUrl});
    favoritesNotifier.value = List.from(favoritesNotifier.value);
  }

  // Remove a book from favorites in Firestore and notify listeners
  Future<void> removeFavorite(String title) async {
    final currentUser = AuthService().getCurrentUser();
    if (currentUser == null) return;

    final userId = currentUser.uid;
    final favoriteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites');

    final favoriteDocs = await favoriteRef.where('title', isEqualTo: title).get();
    for (var doc in favoriteDocs.docs) {
      await doc.reference.delete();
    }

    // Update local favorites list
    favoritesNotifier.value.removeWhere((book) => book['title'] == title);
    favoritesNotifier.value = List.from(favoritesNotifier.value);
  }

  // Load favorites from Firestore when the user logs in
  Future<void> loadFavorites() async {
    final currentUser = AuthService().getCurrentUser();
    if (currentUser == null) return;

    final userId = currentUser.uid;
    final favoriteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites');

    final favoriteDocs = await favoriteRef.get();
    final favorites = favoriteDocs.docs.map((doc) => {
      'title': doc['title'],
      'pdfUrl': doc['pdfUrl'],
    }).toList();

    favoritesNotifier.value = favorites; // Update the notifier
  }

  // Check if a book is a favorite
  bool isFavorite(String title) {
    return favoritesNotifier.value.any((book) => book['title'] == title);
  }
}
