abstract class OtpAuthState {}

class OtpAuthInitial extends OtpAuthState {}

class OtpAuthLoading extends OtpAuthState {}

class OtpAuthSuccess extends OtpAuthState {}

class OtpAuthFailure extends OtpAuthState {
  final String errorMessage;

  OtpAuthFailure(this.errorMessage);
}
