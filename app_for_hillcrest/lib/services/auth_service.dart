import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../data/translations.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of user data
  Stream<UserModel?> get userModelStream {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _db.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!);
    });
  }

  // Sign up
  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required String language,
  }) async {
    try {
      // Check uniqueness of username and full name
      final usernameCheck = await _db
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (usernameCheck.docs.isNotEmpty) {
        return 'Username already exists';
      }

      final fullNameCheck = await _db
          .collection('users')
          .where('fullName', isEqualTo: fullName)
          .get();
      if (fullNameCheck.docs.isNotEmpty) {
        return 'Full name already registered';
      }

      // Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        bool isAdmin = username.endsWith('.adminHILLCREST');

        UserModel newUser = UserModel(
          uid: user.uid,
          username: username,
          email: email,
          fullName: fullName,
          selectedLanguage: language,
          isAdmin: isAdmin,
        );

        // Save user data to Firestore
        await _db.collection('users').doc(user.uid).set(newUser.toMap());
        
        // Update app language
        TranslationService.currentLanguage.value = language;
        
        return null; // Success
      }
      return 'User creation failed';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Login
  Future<String?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Load user language
      final doc = await _db.collection('users').doc(userCredential.user!.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        TranslationService.currentLanguage.value = data['selectedLanguage'] ?? 'English (US)';
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Delete account
  Future<String?> deleteAccount(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return 'No user logged in';

      // Re-authenticate user before deleting
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Delete from Firestore
      await _db.collection('users').doc(user.uid).delete();
      
      // Delete from Auth
      await user.delete();
      
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Change password
  Future<String?> changePassword(String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return 'No user logged in';

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
