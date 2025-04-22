

import '../data_source/review_data_source.dart';
import '../data_source/user_data_source.dart';
import '../model/review_model.dart';

class ReviewRepository {
  final ReviewDataSource _reviewDataSource;
  final UserDataSource _userDataSource;

  ReviewRepository(this._reviewDataSource, this._userDataSource);

  Future<void> submitReview(Review review) {
    return _reviewDataSource.addReview(review);
  }

  Future<List<ReviewWithUser>> getProductReviews(String productId) async {
    final reviews = await _reviewDataSource.getReviewsByProduct(productId);

    final List<ReviewWithUser> enrichedReviews = [];
    for (final review in reviews) {
      final user = await _userDataSource.getUserById(review.userId);
      enrichedReviews.add(ReviewWithUser(review: review, user: user));
    }

    return enrichedReviews;
  }
}
