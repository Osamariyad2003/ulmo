import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ulmo/features/review/presentation/controller/review_%20bloc.dart';
import 'package:ulmo/features/review/presentation/controller/review_state.dart';

import '../../data/model/review_model.dart';
import '../controller/review_event.dart';





class NewReviewScreen extends StatefulWidget {
  final String productId;
  final String userId;

  const NewReviewScreen({
    Key? key,
    required this.productId,
    required this.userId,
  }) : super(key: key);

  @override
  State<NewReviewScreen> createState() => _NewReviewScreenState();
}

class _NewReviewScreenState extends State<NewReviewScreen> {
  double _rating = 4;
  String _reviewText = '';
  final List<File> _images = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _images.add(File(picked.path)));
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final ratingLabel = {
      1: 'Terrible',
      2: 'Bad',
      3: 'Okay',
      4: 'Nice',
      5: 'Excellent'
    };

    return Scaffold(
      appBar: AppBar(
        title:  Text('New review'),
        centerTitle: true,
        leading:  BackButton(),
      ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBar.builder(
                  initialRating: _rating,
                  allowHalfRating: false,
                  minRating: 1,
                  itemSize: 40,
                  itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) => setState(() => _rating = rating),
                ),
                Center(
                  child: Text(
                    ratingLabel[_rating.toInt()] ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 3,
                  onChanged: (text) => _reviewText = text,
                  decoration: InputDecoration(
                    hintText: 'Your review',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (_, index) => Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _images[index],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -6,
                                right: -6,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 16),
                                  onPressed: () => _removeImage(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // ✅ space before button

                BlocBuilder<ReviewBloc, ReviewState>(
                  builder: (context, state) {
                    final bloc = context.read<ReviewBloc>();

                    return ElevatedButton(
                      onPressed: () {
                        final review = Review(
                          comment: _reviewText,
                          rating: _rating,
                          createdAt: DateTime.now(),
                          productId: widget.productId,
                          userId: widget.userId,
                          imageUrls: [], // handled in bloc after upload
                        );

                        bloc.add(SubmitProductReview(review));
                        Navigator.pop(context); // optional after submission
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: state is ReviewSubmitting
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('Send review'),
                    );
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}

