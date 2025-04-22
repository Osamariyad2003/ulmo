import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ulmo/core/local/caches_keys.dart';
import '../../../../core/models/user.dart';


class AuthRepositoryImpl {
  final fb.FirebaseAuth _firebaseAuth;
  final FlutterSecureStorage _secureStorage;
  final GoogleSignIn _googleSignIn;

  static const String _tokenKey = CacheKeys.cachedUserId;

  AuthRepositoryImpl({
    required fb.FirebaseAuth firebaseAuth,
    required FlutterSecureStorage secureStorage,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _secureStorage = secureStorage,
        _googleSignIn = googleSignIn;

  Future<User> loginWithEmail({required String email, required String password}) async {
    final credential = await _firebaseAuth?.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fb.User? firebaseUser = credential?.user;
    if (firebaseUser == null) {
      throw Exception("Login failed: user not found.");
    }
    final token = await firebaseUser.getIdToken();
    await _secureStorage?.write(key: _tokenKey, value: token);
    return AddFirebaseUserToUser(firebaseUser);
  }

  Future<User> loginWithGoogle() async {
    final googleUser = await _googleSignIn?.signIn();
    if (googleUser == null) {
      throw Exception("Google sign in aborted.");
    }
    final googleAuth = await googleUser.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final fb.User? firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw Exception("Google login failed: user not found.");
    }
    final token = await firebaseUser.getIdToken();
    await _secureStorage.write(key: _tokenKey, value: token);
    return AddFirebaseUserToUser(firebaseUser);
  }

  Future<User> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String country,
  }) async {
    try {
      print('🚀 Registering user with email: $email');

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fb.User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception("❌ Registration failed: no user created.");
      }

      print('✅ Firebase user created: ${firebaseUser.uid}');

      await firebaseUser.updateDisplayName(name);
      final token = await firebaseUser.getIdToken();

      print('✅ User token generated: $token');

      await _secureStorage.write(key: _tokenKey, value: token);

      print('✅ Storing user data in Firestore...');

      final user = AddFirebaseUserToUser(
        firebaseUser,
        id: firebaseUser.uid,
        username: name,
        email: email,
        phoneNumber: phone,
        country: country,
      );

      print('✅ User object created: $user');

      await FirebaseFirestore.instance.collection('users').doc(user.id).set(user.toMap());

      print('✅ User successfully added to Firestore');

      return user;
    } on fb.FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.message}');
      throw Exception("Registration failed: ${e.message}");
    } catch (e, stacktrace) {
      print('❌ Unexpected Exception: $e');
      print(stacktrace);
      throw Exception("Registration failed: ${e.toString()}");
    }
  }



  Future<void> logout() async {
    await _firebaseAuth?.signOut();
    await _googleSignIn?.signOut();
    await _secureStorage?.delete(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage?.read(key: _tokenKey);
    return token != null;
  }

  Future<User> verifyOtp({
    required String verificationId,
    required String otpCode,
  }) async {
    try {
      final credential = fb.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );
      final userCredential = await _firebaseAuth?.signInWithCredential(credential);
      final fb.User? firebaseUser = userCredential?.user;

      if (firebaseUser == null) {
        throw Exception("OTP verification failed: no user found.");
      }
      final token = await firebaseUser.getIdToken();
      await _secureStorage?.write(key: _tokenKey, value: token);

      return AddFirebaseUserToUser(firebaseUser);
    } catch (e) {
      print(e);
      throw Exception("OTP verification error: ${e.toString()}");
    }
  }


  User AddFirebaseUserToUser(
      fb.User firebaseUser, {
        String? id,
        String? username,
        String? email,
        String? phoneNumber,
        String? country,
      }) {

    return User(
      id: id ??firebaseUser.uid,
      email: firebaseUser.email ?? '',
      username: username ?? firebaseUser.displayName ?? '',
      phoneNumber: phoneNumber ?? '',
      country: country ?? '',
      avatarUrl: firebaseUser.photoURL ?? '',
      createdAt: DateTime.now(),
    );
  }
}
