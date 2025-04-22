import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/review_model.dart';

class ReviewDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReview(Review review) async {
    await _firestore.collection('review').add(review.toMap());
  }

  Future<List<Review>> getReviewsByProduct(String productId) async {
    final snapshot = await _firestore
        .collection('review')
        .where('productId', isEqualTo: productId)
        .get();

    return snapshot.docs
        .map((doc) => Review.fromJson(doc as Map<String, dynamic>))
        .toList();
  }
}
