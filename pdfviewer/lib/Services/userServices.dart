import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Models/User.dart';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

Future<void> updateUser(UserModel user) async {
  try {
    await _usersCollection.doc(user.uid).update(user.toMap());
  } catch (e) {
    print(e.toString());
  }
}

Future<String?> uploadProfileImage(String uid, File image) async {
  try {
    // Create a reference to the location where the profile image will be stored
    Reference ref = FirebaseStorage.instance.ref().child('profile_images').child('$uid.jpg');

    // Upload the file to Firebase Storage
    UploadTask uploadTask = ref.putFile(image);

    // Get the download URL
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  } catch (e) {
    print(e.toString());
    return null;
  }
}



