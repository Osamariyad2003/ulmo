import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/auth/domain/usecases/login_google_usecase.dart';
import 'package:ulmo/features/auth/domain/usecases/login_usecase.dart';

import '../../../../../core/local/caches_keys.dart';
import '../../../../../core/local/secure_storage_helper.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginStates> {
  final  LoginWithEmailUseCase loginWithEmailUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;

  bool isObsecure = true;

  LoginBloc(this.loginWithEmailUseCase,this.loginWithGoogleUseCase) : super(LoginInitialState(isPassword:false )) {
    on<signInWithEmailAndPasswordEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        final response = await loginWithEmailUseCase.call(
          email: event.email,
          password: event.password,
        );

        _setSecuredUserId(response.id);
        emit(LoginSuccessState(response));
      } catch (e) {
        log(e.toString());
        emit(LoginErrorState('An unexpected error occurred: ${e.toString()}'));
      }
    });
    on<signInGoogleEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        var login = await loginWithGoogleUseCase.call();
        _setSecuredUserId(login.id);
        emit(LoginSuccessState(login));
      } catch (e) {
        emit(LoginErrorState(
            'An error occurred during Google sign in: ${e.toString()}'));
      }
    });

    on<TogglePasswordEvent>((event,emit){
      emit(LoginInitialState(isPassword:  event.isPassword));
    }
    );
  }

  void _setSecuredUserId(String userId) {
    SecureStorage.writeToken(
      CacheKeys.cachedUserId,
      userId,
    );
  }
}
