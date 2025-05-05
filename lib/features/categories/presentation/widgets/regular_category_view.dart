import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/di/di.dart';
import 'package:ulmo/features/categories/presentation/controller/category_bloc.dart';
import 'package:ulmo/features/categories/presentation/controller/category_state.dart';
import 'package:ulmo/features/categories/presentation/widgets/category_item.dart';
import 'package:ulmo/features/product/presentation/controller/product_bloc.dart';
import 'package:ulmo/features/product/presentation/controller/product_event.dart';
import 'package:ulmo/features/product/presentation/views/product_screen.dart';

class RegularCategoriesView extends StatelessWidget {
  const RegularCategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is CategoryLoaded,
          builder: (context) {
            final categories = (state as CategoryLoaded).categories;

            if (categories.isEmpty) {
              return const Center(child: Text('No categories available'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: categories.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryItem(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider<ProductBloc>(
                                    create:
                                        (_) =>
                                            di<ProductBloc>()..add(
                                              LoadProductsEvent(category.id),
                                            ),
                                    child: ProductScreen(
                                      parentid: category.id,
                                      parentCategory: category.name,
                                    ),
                                  ),
                            ),
                          );
                        },
                        category: category,
                      );
                    },
                  ),
                ),
              ],
            );
          },
          fallback: (context) {
            if (state is CategoryError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is CategoryLoading || state is CategoryInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: Text('No categories found'));
          },
        );
      },
    );
  }
}
