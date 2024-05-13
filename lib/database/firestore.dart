import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
// current logged in use
  User? user = FirebaseAuth.instance.currentUser;

// Get Collection of posts from firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');
  final CollectionReference products =
      FirebaseFirestore.instance.collection('Products');

// Post a message
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

//read a message from database
  Stream<QuerySnapshot> getPostStream() {
    final postStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();
    return postStream;
  }

//Delete post
  Future<void> deleteNote(String docID) {
    return posts.doc(docID).delete();
  }

//...................................................Products................................................

  Future<void> addProduct(String title, String description, String phone,
      String price, String imageUrl) {
    return products.add({
      'UserEmail': user!.email,
      'Title': title,
      'Description': description,
      'PhoneNo': phone,
      'Price': price,
      'ImageUrl': imageUrl,
      'TimeStamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getProductStream() {
    final productStream = FirebaseFirestore.instance
        .collection('Products')
        .orderBy('TimeStamp', descending: true)
        .snapshots();
    return productStream;
  }

  Future<void> deleteProduct(String docID) {
    return products.doc(docID).delete();
  }

//
}
