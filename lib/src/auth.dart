import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    if (user != null) {
      // Crează un document pentru noul utilizator în Firestore
      await _firestore.collection('Utilizatori').doc(user.uid).set({
        'email': user.email,
        'puncte': 0, // Valoare inițială pentru puncte
        'data_ultimei_donari': null,
        'istoric_donari': [],
      });
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
