import 'package:ulmo/features/auth/data/repo/auth_repo.dart';

import '../../../../core/models/user.dart';

class LoginWithEmailUseCase {
  final AuthRepositoryImpl repository;
  LoginWithEmailUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
  }) async {
    return await repository.loginWithEmail(email: email, password: password);
  }
}