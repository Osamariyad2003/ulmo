import '../../../../../core/models/user.dart';

abstract class LoginStates{}

class LoginInitialState extends LoginStates{
  final bool isPassword;
  LoginInitialState({required this.isPassword});

}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates {
  User userCredential;
  LoginSuccessState(this.userCredential);

}
class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error);
}