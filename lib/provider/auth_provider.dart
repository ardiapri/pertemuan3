import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  User? get user => _user;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _user = _auth.currentUser;

    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      _user = credential.user;

      _setLoading(false);
      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e);

      _setLoading(false);
      notifyListeners();

      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat login.';

      _setLoading(false);
      notifyListeners();

      return false;
    }
  }

  Future<bool> register(
    String email,
    String password,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      _user = credential.user;

      await _auth.signOut();

      _user = null;

      _setLoading(false);
      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e);

      _setLoading(false);
      notifyListeners();

      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat membuat akun.';

      _setLoading(false);
      notifyListeners();

      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();

    _user = null;
    _errorMessage = null;

    notifyListeners();
  }

  String _getFirebaseErrorMessage(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';

      case 'user-not-found':
        return 'Email belum terdaftar.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau password salah.';

      case 'email-already-in-use':
        return 'Email sudah digunakan.';

      case 'weak-password':
        return 'Password terlalu lemah.';

      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan coba lagi nanti.';

      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';

      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';

      default:
        return 'Login atau pendaftaran gagal.';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}