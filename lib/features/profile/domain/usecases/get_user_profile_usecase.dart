import '../../../../core/models/user.dart' as app_models;
import '../../data/repo/profile_repo.dart';

class GetUserProfileUseCase {
  final ProfileRepo profileRepo;

  GetUserProfileUseCase(this.profileRepo);

  Future<app_models.User> call() async {
    return await profileRepo.getUserProfile();
  }
}
