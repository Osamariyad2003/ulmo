import 'package:ulmo/core/models/user.dart';

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {
  final bool termsAccepted;
  final bool isPassword;

  RegisterInitialState({this.termsAccepted = false, this.isPassword=false});
}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final User user;

  RegisterSuccessState(this.user);
}

class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState(this.message);
}
