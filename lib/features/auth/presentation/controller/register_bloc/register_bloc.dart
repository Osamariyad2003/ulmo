import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/auth/data/repo/auth_repo.dart';
import 'package:ulmo/features/auth/domain/usecases/login_usecase.dart';
import 'package:ulmo/features/auth/presentation/controller/register_bloc/register_event.dart';
import 'package:ulmo/features/auth/presentation/controller/register_bloc/register_state.dart';

import '../../../../../core/models/user.dart';
import '../../../domain/usecases/register_usecase.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterUserUseCase registerUserUseCase;

  RegisterBloc(this.registerUserUseCase) : super(RegisterInitialState(isPassword: false)) {
    on<SignUpEvent>((event, emit) async {
      emit(RegisterLoadingState());

      try {
        final User? userModel =
        await registerUserUseCase.call(
          email: event.email,
          password: event.password,
          name: event.username,
           phone: event.phone,
          country: event.country,
        );

        emit(RegisterSuccessState(userModel??User(id: '',phoneNumber: '',
            email: '',username: '',
            country: '',createdAt: DateTime.now())));

      } catch (error) {
        emit(RegisterErrorState(error.toString()));
      }
    });


    on<ToggleTermsEvent>((event, emit) {
      emit(RegisterInitialState(
        termsAccepted: event.isAccepted,
      ));
    });
    on<TogglePasswordEvent>((event, emit) {
      emit(RegisterInitialState(isPassword: event.isPassword));
    });
  }
}
