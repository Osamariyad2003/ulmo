import '../../data/model/review_model.dart';
import '../../data/repo/review_repo.dart';

class GetProductReviews {
  final ReviewRepository repository;

  GetProductReviews(this.repository);

  Future<List<ReviewWithUser>> call(String productId) {
    return repository.getProductReviews(productId);
  }
}