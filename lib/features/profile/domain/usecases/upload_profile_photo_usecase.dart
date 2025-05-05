import 'dart:io';
import '../../data/repo/profile_repo.dart';

class UploadProfilePhotoUseCase {
  final ProfileRepo profileRepo;

  UploadProfilePhotoUseCase(this.profileRepo);

  Future<String> call(File photo) async {
    return await profileRepo.uploadProfilePhoto(photo);
  }
}
