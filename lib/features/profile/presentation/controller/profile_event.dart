import 'dart:io';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> profileData;

  UpdateProfile({required this.profileData});
}

class UploadProfilePhoto extends ProfileEvent {
  final File photo;

  UploadProfilePhoto({required this.photo});
}

class UpdateProfileWithPhoto extends ProfileEvent {
  final Map<String, dynamic> profileData;
  final File photo;

  UpdateProfileWithPhoto({
    required this.profileData,
    required this.photo,
  });
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
}

class LoadOrders extends ProfileEvent {}

class SignOut extends ProfileEvent {}
