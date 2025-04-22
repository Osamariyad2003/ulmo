import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/local/caches_keys.dart';
import '../../../../core/di/di.dart';
import '../../../../core/local/secure_storage_helper.dart';
import '../controller/review_ bloc.dart';
import '../controller/review_event.dart';
import '../controller/review_state.dart';
import '../widgets/new_review_screen.dart';
import '../widgets/review_tile.dart';

class ReviewListScreen extends StatelessWidget {
  final String productId;

   ReviewListScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => di<ReviewBloc>()..add(LoadProductReviews(productId)),
      child: Scaffold(
        appBar: AppBar(
          leading:  BackButton(),
          title:  Text('Reviews'),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => di<ReviewBloc>(), // from your DI
                      child: NewReviewScreen(
                        productId: productId,
                        userId: CacheKeys.cachedUserId,
                      ),
                    ),
                  ),
                );

              },
              child:  Text('New review'),
            ),
          ],
        ),
        body: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            if (state is ReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReviewLoaded) {
              final reviews = state.reviews;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reviews.length,
                itemBuilder: (_, index) => ReviewTile(review: reviews[index]),
              );
            } else if (state is ReviewError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
