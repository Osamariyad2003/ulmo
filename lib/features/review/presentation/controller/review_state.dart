import '../../data/model/review_model.dart';

abstract class ReviewState  {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewWithUser> reviews;

   ReviewLoaded(this.reviews);


}

class ReviewError extends ReviewState {
  final String message;

   ReviewError(this.message);
}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitted extends ReviewState {}
