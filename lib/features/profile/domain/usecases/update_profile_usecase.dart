import '../../../../core/models/user.dart' as app_models;
import '../../data/repo/profile_repo.dart';

class UpdateProfileUseCase {
  final ProfileRepo profileRepo;

  UpdateProfileUseCase(this.profileRepo);

  Future<app_models.User> call(Map<String, dynamic> profileData) async {
    return await profileRepo.updateProfile(profileData);
  }
}
