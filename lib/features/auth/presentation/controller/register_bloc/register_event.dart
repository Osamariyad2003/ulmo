abstract class RegisterEvent {}

class SignUpEvent extends RegisterEvent {
  final String email;
  final String password;
  final String username;
  final String phone;
  final String country;


  SignUpEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.phone,
    required this.country,
  });
}

class SignOutEvent extends RegisterEvent {}

class ToggleTermsEvent extends RegisterEvent {
  final bool isAccepted;

  ToggleTermsEvent(this.isAccepted);
}
class TogglePasswordEvent extends RegisterEvent {
  final bool isPassword;

  TogglePasswordEvent(this.isPassword);
}