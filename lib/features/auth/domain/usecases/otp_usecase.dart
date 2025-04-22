import 'package:ulmo/features/auth/data/repo/auth_repo.dart';

import '../../../../core/models/user.dart';

class VerifyOtpUseCase {
  final AuthRepositoryImpl repository;
  VerifyOtpUseCase(this.repository);

  Future<User> call({
    required String verificationId,
    required String otpCode,
  }) async {
    return await repository.verifyOtp(
      verificationId: verificationId,
      otpCode: otpCode,
    );
  }
}