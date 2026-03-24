import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim());

      await _firestore.collection("users")
          .doc(userCredential.user!.uid)
          .set({
        'name': name.trim(),
        'email': email.trim(),
        'role': role,
        'profileCompleted': false,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim());

      DocumentSnapshot userDoc = await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      return {
        "role": userDoc['role'].toString().trim(),
        "profileCompleted": userDoc['profileCompleted'] ?? true
      };

    } catch (e) {
      return null;
    }
  }

  Future<String?> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) return "cancelled";

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);//shared prefernce

      final user = userCredential.user;

      if (user == null) return "error";

      final doc = await _firestore
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return doc['role'];
      } else {
        return "NEW_USER";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> saveUserRole(String role) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection("users").doc(user.uid).set({
      'email': user.email,
      'role': role,
    });
  }
}