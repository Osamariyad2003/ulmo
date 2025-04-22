import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/model/review_model.dart';


class ReviewTile extends StatelessWidget {
  final ReviewWithUser review;

  const ReviewTile({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rating = review.review.rating;
    final comment = review.review.comment;
    final createdAt = review.review.createdAt;
    final username = review.user.username;
    final userImage = review.user.avatarUrl;
    final images = review.review.imageUrls;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating + Date
          Row(
            children: [
              RatingBarIndicator(
                rating: rating,
                itemCount: 5,
                itemSize: 20,
                itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
              ),
              const Spacer(),
              Text(
                timeago.format(createdAt),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // User info
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userImage??""),
                radius: 16,
              ),
              const SizedBox(width: 8),
              Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),

          // Comment
          Text(comment, style:  TextStyle(fontSize: 14, color: Colors.grey[800])),

          const SizedBox(height: 10),

          // Images (optional)
          if (images.isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (_, index) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[index],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
