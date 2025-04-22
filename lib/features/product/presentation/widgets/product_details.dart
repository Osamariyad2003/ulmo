import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/themes/colors_style.dart';
import 'package:ulmo/core/utils/widgets/custom_button.dart';
import 'package:ulmo/features/bag/data/models/bag_item_model.dart';
import 'package:ulmo/features/product/presentation/widgets/product_info.dart';
import 'package:ulmo/features/review/presentation/views/review_list_screen.dart';
import '../../../../core/models/product.dart';
import '../../../bag/presentation/controller/bag_bloc.dart';
import '../../../bag/presentation/controller/bag_event.dart';
import '../../../favorite/presentation/controller/favorite_bloc.dart';
import '../../../favorite/presentation/controller/favorite_event.dart';
import '../../../favorite/presentation/controller/favorite_state.dart';


class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({required this.product, Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedVariant = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: PageView.builder(
                    itemCount: widget.product.imageUrls.length,
                    itemBuilder: (context, index) => Image.network(
                      widget.product.imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon:  Icon(Icons.arrow_back,color: Colors.black,),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: BlocBuilder<FavoriteBloc, FavoriteState>(
                      builder: (context, state) {
                        final isFav = context.read<FavoriteBloc>().isFavorite(widget.product.id);

                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            final bloc = context.read<FavoriteBloc>();
                            if (isFav) {
                              bloc.add(RemoveFromFavorite(widget.product.id));
                            } else {
                              bloc.add(AddToFavorite(widget.product));
                            }
                            setState(() {}); // Force icon update
                          },
                        );
                      },
                    )



                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Variants
                  if (widget.product.variants != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.product.variants!.asMap().entries.map((entry) {
                          int idx = entry.key;
                          String variant = entry.value;
                          return GestureDetector(
                            onTap: () => setState(() => selectedVariant = idx),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: selectedVariant == idx
                                    ? Colors.black
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                variant,
                                style: TextStyle(
                                  color: selectedVariant == idx
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Product information'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductInformationScreen(
                            product: widget.product,
                          ),
                        ),
                      );
                    },
                  ),

                  // Reviews
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title:  Text('Reviews'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=> ReviewListScreen(productId: widget.product.id)));
                    },
                  ),

                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      final product = widget.product;

                      final bagItem = BagItemModel(
                        productId: product.id,
                        name: product.title,
                        price: product.price,
                        imageUrl: product.imageUrls.first,
                        quantity: 1,
                      );

                      context.read<BagBloc>().add(AddItemEvent(bagItem));

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to bag!')),
                      );
                    },


                    icon:  Icon(Icons.shopping_bag_outlined,color: Colors.black,),
                    label:  Text('Add to bag'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
