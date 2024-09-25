import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FavoritesManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addFavorite(Map<String, dynamic> book) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    String userId = user.uid;
    await _firestore.collection('users').doc(userId).collection('favorites').add(book);
  }

  Future<void> removeFavorite(String bookId) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    String userId = user.uid;
    await _firestore.collection('users').doc(userId).collection('favorites').doc(bookId).delete();
  }
}
