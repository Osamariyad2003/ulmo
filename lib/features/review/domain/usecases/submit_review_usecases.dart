import '../../data/model/review_model.dart';
import '../../data/repo/review_repo.dart';

class SubmitReview {
  final ReviewRepository repository;

  SubmitReview(this.repository);

  Future<void> call(Review review) {
    return repository.submitReview(review);
  }
}