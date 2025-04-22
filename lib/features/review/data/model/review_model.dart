import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/models/user.dart';

class Review {
  final String comment;
  final double rating;
  final DateTime createdAt;
  final String productId;
  final String userId;
  final List<String> imageUrls;

  Review({
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.productId,
    required this.userId,
    required this.imageUrls,
  });

  factory Review.fromJson(Map<String, dynamic> data) {
    return Review(
      comment: data['comment'],
      rating: (data['rating'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      productId: data['productId'],
      userId: data['userId'],
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt,
      'productId': productId,
      'userId': userId,
      'imageUrls': imageUrls,
    };
  }
}

class ReviewWithUser {
  final Review review;
  final User user;

  ReviewWithUser({required this.review, required this.user});
}
