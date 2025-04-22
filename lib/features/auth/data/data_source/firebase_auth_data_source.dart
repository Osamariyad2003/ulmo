
import 'dart:io';        // For File
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ulmo/core/errors/expections.dart';
import 'package:ulmo/core/errors/failures.dart';

import '../../../../core/models/user.dart';



class FirebaseAuthDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDataSource({
    fb.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<Either<FirebaseAuthFailure,User>> registerUser({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    required String country,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final fb.User? firebaseUser = credential.user;
    if (firebaseUser == null) {
      return  Left(FirebaseAuthFailure( 'Failed to create user in Firebase Auth'));
    }

    final userDocRef = _firestore.collection('users').doc(firebaseUser.uid);

    final userModel = User(
      id: firebaseUser.uid,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      country: country,
      createdAt: DateTime.now(),
    );

    await userDocRef.set(userModel.toMap());

    return Right(userModel);
  }


  Future<User> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in aborted');

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final fb.User? firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw FireBaseException(message: 'Google login failed');
    }

    final userDocRef = _firestore.collection('users').doc(firebaseUser.uid);
    final doc = await userDocRef.get();

    if (!doc.exists) {
      final userModel = User(
        id: firebaseUser.uid,
        username: firebaseUser.displayName ?? 'Google User',
        email: firebaseUser.email ?? '',
        phoneNumber: firebaseUser.phoneNumber ?? '',
        country: '',
        createdAt: DateTime.now(),
      );

      await userDocRef.set(userModel.toMap());
      return userModel;
    }

    return User.fromMap(doc.data()!);
  }

  Future<User> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final fb.User? firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw FireBaseException(message: 'Failed to login with Firebase Auth');
    }

    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (!doc.exists || doc.data() == null) {
      throw FireBaseException(message: 'User document not found after login');
    }

    return User.fromMap(doc.data()!);
  }




}
