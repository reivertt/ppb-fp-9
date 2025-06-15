import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      print("repo-try regis");
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("repo-firebase err");
      throw Exception(e.code);
    } catch (e) {
      print("repo-err");
      throw const FormatException('An unexpected error occurred.');
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      print("repo-try login");
      final login = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("repo-done login");
      print("repo login returns: ${login}");
      return login;
    } on FirebaseAuthException catch (e) {
      print("repo-firebase error");
      throw Exception(e.code);
    } catch (e) {
      print("repo-error");
      throw const FormatException('An unexpected error occurred.');
    }
  }

  Future<void> saveUserData(User user, String username) async {
    try {
      print("repo-try create user");
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'username': username,
        'email': user.email,
        'createdAt': Timestamp.now(),
      });
      print("repo-don");
    } catch (e) {
      print("repo-user err");
      throw Exception('Could not save user data.');
    }
  }
}