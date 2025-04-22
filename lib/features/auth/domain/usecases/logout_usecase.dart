import 'package:ulmo/features/auth/data/repo/auth_repo.dart';

class LogoutUseCase {
  final AuthRepositoryImpl repository;
  LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
