import '../../data/repo/profile_repo.dart';

class ChangePasswordUseCase {
  final ProfileRepo profileRepo;

  ChangePasswordUseCase(this.profileRepo);

  Future<void> call(String currentPassword, String newPassword) async {
    await profileRepo.changePassword(currentPassword, newPassword);
  }
}
