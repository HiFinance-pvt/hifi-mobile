import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔵 [AuthService] Starting Google Sign In...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('🔵 [AuthService] Google user: ${googleUser?.email}');
      
      if (googleUser == null) {
        print('⚠️ [AuthService] User cancelled Google Sign In');
        return null;
      }

      print('🔵 [AuthService] Getting authentication...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('🔵 [AuthService] Access token: ${googleAuth.accessToken != null}');
      print('🔵 [AuthService] ID token: ${googleAuth.idToken != null}');
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔵 [AuthService] Signing in with credential...');
      final result = await _auth.signInWithCredential(credential);
      print('✅ [AuthService] Sign in successful: ${result.user?.email}');
      return result;
    } catch (e, stackTrace) {
      print('❌ [AuthService] Google sign-in error: $e');
      print('❌ [AuthService] Stack trace: $stackTrace');
      
      if (e.toString().contains('ApiException: 7')) {
        throw 'Network error. Please check:\n1. Internet connection\n2. SHA-1 fingerprint in Firebase Console';
      }
      throw 'Google sign-in failed: ${e.toString()}';
    }
  }

  // Force Google account selection
  Future<UserCredential?> signInWithGoogleForceSelection() async {
    try {
      print('🔵 [AuthService] Force selection - signing out first...');
      // Sign out from Google first to force account selection
      await _googleSignIn.signOut();
      
      print('🔵 [AuthService] Starting Google Sign In (Force)...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('🔵 [AuthService] Google user (Force): ${googleUser?.email}');
      
      if (googleUser == null) {
        print('⚠️ [AuthService] User cancelled Google Sign In (Force)');
        return null;
      }

      print('🔵 [AuthService] Getting authentication (Force)...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔵 [AuthService] Signing in with credential (Force)...');
      final result = await _auth.signInWithCredential(credential);
      print('✅ [AuthService] Sign in successful (Force): ${result.user?.email}');
      return result;
    } catch (e, stackTrace) {
      print('❌ [AuthService] Google sign-in (Force) error: $e');
      print('❌ [AuthService] Stack trace: $stackTrace');
      throw 'Google sign-in failed: ${e.toString()}';
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
    await _clearRememberMe();
  }

  // Remember me functionality
  Future<void> saveRememberMe(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remembered_email', email);
    await prefs.setBool('remember_me', true);
  }

  Future<String?> getRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    if (rememberMe) {
      return prefs.getString('remembered_email');
    }
    return null;
  }

  Future<void> _clearRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remembered_email');
    await prefs.remove('remember_me');
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}