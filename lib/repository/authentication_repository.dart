import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late final Rx<User?> firebaseUser;

  @override
  void onInit(){
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw const FormatException('An unexpected error occurred.');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw const FormatException('An unexpected error occurred.');
    }
  }

  Future<void> saveUserData(User user, String username) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'username': username,
        'email': user.email,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Could not save user data.');
    }
  }

  Future<void> logout() async => await _auth.signOut();
}