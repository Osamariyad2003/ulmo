import 'package:ulmo/features/auth/data/repo/auth_repo.dart';


class IsLoggedInUseCase {
  final AuthRepositoryImpl repository;
  IsLoggedInUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isLoggedIn();
  }
}
