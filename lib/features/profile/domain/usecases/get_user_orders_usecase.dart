import '../../data/repo/profile_repo.dart';

class GetUserOrdersUseCase {
  final ProfileRepo profileRepo;

  GetUserOrdersUseCase(this.profileRepo);

  Future<List<Map<String, dynamic>>> call() async {
    return await profileRepo.getUserOrders();
  }
}
