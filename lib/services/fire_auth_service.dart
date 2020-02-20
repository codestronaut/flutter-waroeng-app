/* IMPORT PACKAGE */
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

// Kelas Abstrak untuk Authentifikasi
abstract class BaseAuth {
  Future<String> signIn(String _email, String _password);
  Future<String> signUp(String _email, String _password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> sendEmailVeification();
  Future<void> signOut();
  Future<bool> isEmailVerified;
}

// Class yang mengimplementasikan kelas abstrak
class Auth implements BaseAuth {
  // Memperoleh object dari FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Memvalidasi apakah email terverifikasi
  @override
  Future<bool> isEmailVerified;

  // Mendapatkan informasi tentang user terbaru yang login
  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  // Mengirim email verifikasi kepada email pendaftar
  @override
  Future<void> sendEmailVeification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.sendEmailVerification();
  }

  // Melakukan login
  @override
  Future<String> signIn(String _email, String _password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: _email, password: _password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  // Keluarkan akun
  @override
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Mendaftarkan akun baru
  @override
  Future<String> signUp(String _email, String _password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: _email, password: _password);
    FirebaseUser user = result.user;
    return user.uid;
  }
}
