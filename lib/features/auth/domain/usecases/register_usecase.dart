import 'package:ulmo/features/auth/data/repo/auth_repo.dart';

import '../../../../core/models/user.dart';

class RegisterUserUseCase {
  final AuthRepositoryImpl repository;
  RegisterUserUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String country,
  }) async {
    return await repository.registerUser(
      email: email,
      password: password,
      name: name,
      phone: phone,
      country: country,
    );
  }
}