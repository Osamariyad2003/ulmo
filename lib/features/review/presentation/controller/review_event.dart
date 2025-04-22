import '../../data/model/review_model.dart';

abstract class ReviewEvent  {}

class LoadProductReviews extends ReviewEvent {
  final String productId;
  LoadProductReviews(this.productId);
}

class SubmitProductReview extends ReviewEvent {
  final Review review;
  SubmitProductReview(this.review);
}
