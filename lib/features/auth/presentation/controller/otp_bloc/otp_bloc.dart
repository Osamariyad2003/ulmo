import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/otp_usecase.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpAuthBloc extends Bloc<OtpAuthEvent, OtpAuthState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  OtpAuthBloc(this.verifyOtpUseCase) : super(OtpAuthInitial()) {
    on<VerifyOtpEvent>(_verifyOtp);
  }

  Future<void> _verifyOtp(
      VerifyOtpEvent event,
      Emitter<OtpAuthState> emit,
      ) async {
    emit(OtpAuthLoading());
    try {
      final user = await verifyOtpUseCase(
        verificationId: event.verificationId,
        otpCode: event.otpCode,
      );
      emit(OtpAuthSuccess());
    } catch (e) {
      emit(OtpAuthFailure(e.toString()));
    }
  }
}
