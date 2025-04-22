import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_prodect_review.dart';
import '../../domain/usecases/submit_review_usecases.dart';
import 'review_event.dart';
import 'review_state.dart';


class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetProductReviews getProductReviews;
  final SubmitReview submitReview;

  ReviewBloc({
    required this.getProductReviews,
    required this.submitReview,
  }) : super(ReviewInitial()) {
    on<LoadProductReviews>(_onLoadReviews);
    on<SubmitProductReview>(_onSubmitReview);
  }

  Future<void> _onLoadReviews(
      LoadProductReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final reviews = await getProductReviews(event.productId);
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError("Failed to load reviews"));
    }
  }

  Future<void> _onSubmitReview(
      SubmitProductReview event, Emitter<ReviewState> emit) async {
    emit(ReviewSubmitting());
    try {
      await submitReview(event.review);
      emit(ReviewSubmitted());
    } catch (e) {
      emit(ReviewError("Failed to submit review"));
    }
  }
}
