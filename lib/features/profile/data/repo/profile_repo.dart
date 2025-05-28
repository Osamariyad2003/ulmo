import 'dart:io';

import 'package:ulmo/features/profile/data/data_source/local_data_source/card_data_source.dart';
import 'package:ulmo/features/profile/data/models/credit_card.dart';

import '../../../../core/models/user.dart' as app_models;
import '../data_source/profile_data_source.dart';

class ProfileRepo {
  final ProfileDataSource profileDataSource;
  final HiveCardStorage cardLocalSource;

  ProfileRepo({required this.profileDataSource, required this.cardLocalSource});

  Future<app_models.User> getUserProfile() async {
    try {
      return await profileDataSource.getCurrentUserProfile();
    } catch (error) {
      // Simply rethrow the error for handling at the UI level
      rethrow;
    }
  }

  Future<app_models.User> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
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
    String currentPassword,
    String newPassword,
  ) async {
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

  // Payment methods related functionality
  Future<List<CreditCard>> getPaymentMethods() async {
    try {
      final cards = await cardLocalSource.getCards();
      return cards;
    } catch (error) {
      throw Exception('Failed to fetch payment methods: $error');
    }
  }

  Future<String?> getDefaultCardId() async {
    try {
      return await cardLocalSource.getDefaultCardId();
    } catch (error) {
      throw Exception('Failed to get default payment method: $error');
    }
  }

  Future<void> setDefaultPaymentMethod(String cardId) async {
    try {
      await cardLocalSource.setDefaultCard(cardId);
    } catch (error) {
      throw Exception('Failed to set default payment method: $error');
    }
  }

  Future<void> deletePaymentMethod(String cardId) async {
    try {
      await cardLocalSource.deleteCard(cardId);
    } catch (error) {
      throw Exception('Failed to delete payment method: $error');
    }
  }

  Future<void> addPaymentMethod(CreditCard card) async {
    try {
      await cardLocalSource.saveCard(card);
    } catch (error) {
      throw Exception('Failed to add payment method: $error');
    }
  }
}
