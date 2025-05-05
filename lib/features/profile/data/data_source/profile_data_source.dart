import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/errors/expections.dart';
import '../../../../core/models/user.dart' as app_models;

class ProfileDataSource {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<app_models.User> getCurrentUserProfile() async {
    try {
      final firebase_auth.User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw FireBaseException(message: 'User not authenticated');
      }

      final docSnapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!docSnapshot.exists) {
        throw FireBaseException(message: 'User profile not found');
      }

      final data = docSnapshot.data() as Map<String, dynamic>;

      data['id'] = docSnapshot.id;

      return app_models.User.fromMap(data);
    } catch (error) {
      throw FireBaseException(
        message: 'Error fetching profile: ${error.toString()}',
      );
    }
  }

  Future<app_models.User> updateUserProfile(
      Map<String, dynamic> profileData) async {
    try {
      final firebase_auth.User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw FireBaseException(message: 'User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update(profileData);

      // Refresh and return the updated profile
      return getCurrentUserProfile();
    } catch (error) {
      throw FireBaseException(
        message: 'Error updating profile: ${error.toString()}',
      );
    }
  }

  Future<String> uploadProfilePhoto(File photo) async {
    try {
      final firebase_auth.User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw FireBaseException(message: 'User not authenticated');
      }

      // Create a storage reference
      final storageRef =
          _storage.ref().child('profile_photos/${currentUser.uid}');

      // Upload the file
      final uploadTask = await storageRef.putFile(photo);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update the user profile with the new photo URL
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({'avatarUrl': downloadUrl});

      return downloadUrl;
    } catch (error) {
      throw FireBaseException(
        message: 'Error uploading profile photo: ${error.toString()}',
      );
    }
  }

  // Change password for email/password users
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final firebase_auth.User? user = _auth.currentUser;

      if (user == null) {
        throw FireBaseException(message: 'User not authenticated');
      }

      // For email/password authentication, reauthenticate before changing password
      if (user.email != null) {
        // Create credential
        firebase_auth.AuthCredential credential =
            firebase_auth.EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        // Reauthenticate
        await user.reauthenticateWithCredential(credential);

        // Change password
        await user.updatePassword(newPassword);
      } else {
        throw FireBaseException(
            message: 'Cannot change password for this account type');
      }
    } catch (error) {
      throw FireBaseException(
        message: 'Error changing password: ${error.toString()}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> getUserOrders() async {
    try {
      final firebase_auth.User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw FireBaseException(message: 'User not authenticated');
      }

      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: currentUser.uid)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (error) {
      throw FireBaseException(
        message: 'Error fetching user orders: ${error.toString()}',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      throw FireBaseException(
        message: 'Error signing out: ${error.toString()}',
      );
    }
  }
}
