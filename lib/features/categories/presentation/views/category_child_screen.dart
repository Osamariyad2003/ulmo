import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../product/presentation/controller/product_bloc.dart';
import '../../../product/presentation/controller/product_event.dart';
import '../../../product/presentation/views/product_screen.dart';
import '../controller/category_bloc.dart';
import '../controller/category_event.dart';
import '../controller/category_state.dart';
import '../widgets/category_item.dart';
import '../widgets/custom_scaffold.dart';

class ParentCategoryScreen extends StatelessWidget {
  final String parentDocId;
  final String parentTitle;

  const ParentCategoryScreen({
    Key? key,
    required this.parentDocId,
    required this.parentTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              di<CategoryBloc>()
                ..add(FetchChildCategories(parentId: parentDocId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(parentTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration:  InputDecoration(
                          hintText: 'Search categories',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // Dispatch search event with the query value and parent ID
                          context.read<CategoryBloc>().add(
                            SearchCategories(
                              parentId: parentDocId,
                              query: value,
                            ),
                          );
                        },
                      ),
                    ),
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          return Container(
                            width: 20,
                            height: 20,
                            padding: const EdgeInsets.all(4),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              Text(
                'categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Display categories using BlocBuilder + ConditionalBuilder
              Expanded(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    return ConditionalBuilder(
                      condition: state is CategoryLoaded,
                      builder: (context) {
                        final categories = (state as CategoryLoaded).categories;
                        return ListView.separated(
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
                                                    LoadProductsEvent(
                                                      category.id,
                                                    ),
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
                        );
                      },
                      fallback: (context) {
                        if (state is CategoryError) {
                          return Center(child: Text('Error: ${state.message}'));
                        } else if (state is CategoryLoading ||
                            state is CategoryInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return const Center(child: Text('No categories found'));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
