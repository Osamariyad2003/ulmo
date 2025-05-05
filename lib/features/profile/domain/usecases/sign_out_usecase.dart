import '../../data/repo/profile_repo.dart';

class SignOutUseCase {
  final ProfileRepo profileRepo;

  SignOutUseCase(this.profileRepo);

  Future<void> call() async {
    await profileRepo.signOut();
  }
}
