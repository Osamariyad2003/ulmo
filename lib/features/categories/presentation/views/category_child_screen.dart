import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/categories/presentation/widgets/category_search_bar.dart';
import 'package:ulmo/features/categories/presentation/widgets/regular_category_view.dart';
import 'package:ulmo/features/categories/presentation/widgets/search_result_content.dart';

import '../../../../core/di/di.dart';
import '../../../product/presentation/controller/product_bloc.dart';
import '../../../product/presentation/controller/product_event.dart';
import '../../../product/presentation/views/product_screen.dart';
import '../controller/category_bloc.dart';
import '../controller/category_event.dart';
import '../controller/category_state.dart';
import '../widgets/category_item.dart';
import '../widgets/custom_scaffold.dart';

class ParentCategoryScreen extends StatefulWidget {
  final String parentDocId;
  final String parentTitle;

  const ParentCategoryScreen({
    Key? key,
    required this.parentDocId,
    required this.parentTitle,
  }) : super(key: key);

  @override
  State<ParentCategoryScreen> createState() => _ParentCategoryScreenState();
}

class _ParentCategoryScreenState extends State<ParentCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              di<CategoryBloc>()
                ..add(FetchChildCategories(parentId: widget.parentDocId)),
      lazy: false, // Create immediately, don't wait for first access
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.parentTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  CategorySearchBar(
                    searchController: _searchController,
                    parentDocId: widget.parentDocId,
                    onSearchChanged: (isSearching) {
                      setState(() {
                        _isSearching = isSearching;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Main content - conditionally show search results or regular categories
                  Expanded(
                    child:
                        _isSearching
                            ? SearchResultsView(
                              searchController: _searchController,
                            )
                            : RegularCategoriesView(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
