import 'package:ulmo/features/auth/data/repo/auth_repo.dart';

import '../../../../core/models/user.dart';

class LoginWithGoogleUseCase {
  final AuthRepositoryImpl repository;
  LoginWithGoogleUseCase(this.repository);

  Future<User> call() async {
    return await repository.loginWithGoogle();
  }
}