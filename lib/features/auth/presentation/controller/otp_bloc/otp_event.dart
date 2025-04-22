abstract class OtpAuthEvent {}

class VerifyOtpEvent extends OtpAuthEvent {
  final String verificationId;
  final String otpCode;

  VerifyOtpEvent({required this.verificationId, required this.otpCode});
}
