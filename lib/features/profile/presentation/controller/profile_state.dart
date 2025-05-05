import '../../../../core/models/user.dart' as app_models;

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final app_models.User user;

  ProfileLoaded(this.user);
}

class ProfileUpdated extends ProfileState {
  final app_models.User user;

  ProfileUpdated(this.user);
}

class ProfilePasswordChanged extends ProfileState {}

class ProfilePhotoUploaded extends ProfileState {
  final String photoUrl;

  ProfilePhotoUploaded(this.photoUrl);
}

class ProfileOrdersLoaded extends ProfileState {
  final List<Map<String, dynamic>> orders;

  ProfileOrdersLoaded(this.orders);
}

class ProfileSignedOut extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
