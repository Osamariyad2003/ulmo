import 'dart:io';

import '../../../../core/models/user.dart' as app_models;
import '../data_source/profile_data_source.dart';

class ProfileRepo {
  final ProfileDataSource profileDataSource;

  ProfileRepo({required this.profileDataSource});

  Future<app_models.User> getUserProfile() async {
    try {
      return await profileDataSource.getCurrentUserProfile();
    } catch (error) {
      // Simply rethrow the error for handling at the UI level
      rethrow;
    }
  }

  Future<app_models.User> updateProfile(
      Map<String, dynamic> profileData) async {
    try {
      return await profileDataSource.updateUserProfile(profileData);
    } catch (error) {
      rethrow;
    }
  }

  Future<String> uploadProfilePhoto(File photo) async {
    try {
      return await profileDataSource.uploadProfilePhoto(photo);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await profileDataSource.changePassword(currentPassword, newPassword);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserOrders() async {
    try {
      return await profileDataSource.getUserOrders();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await profileDataSource.signOut();
    } catch (error) {
      rethrow;
    }
  }
}
