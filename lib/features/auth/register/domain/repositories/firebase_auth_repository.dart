import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_registration.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  @override
  Future<void> register(UserReg userRegistration) async {
    final email = userRegistration.account.email.trim();
    final password = userRegistration.account.password.trim();

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final displayName = userRegistration.profile.fullName.trim();
      if (displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
      }

      final user = credential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      final profile = userRegistration.profile;
      final account = userRegistration.account;

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': displayName.isNotEmpty ? displayName : null,
        'username': account.username,
        'rememberMe': account.rememberMe,
        'gender': userRegistration.gender,
        'age': userRegistration.age,
        'genres': userRegistration.genres,
        'phone': profile.phone,
        'dateOfBirth': profile.dateOfBirth,
        'country': profile.country,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to register user');
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to save user profile');
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to sign in');
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final snapshot = await userDoc.get();
        if (!snapshot.exists) {
          await userDoc.set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'signInProvider': 'google',
          }, SetOptions(merge: true));
        } else {
          await userDoc.set({
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to sign in with Google');
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to update user profile');
    }
  }
}


