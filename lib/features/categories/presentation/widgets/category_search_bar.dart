import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/categories/presentation/controller/category_bloc.dart';
import 'package:ulmo/features/categories/presentation/controller/category_event.dart';
import 'package:ulmo/features/categories/presentation/controller/category_state.dart';

class CategorySearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final String parentDocId;
  final Function(bool) onSearchChanged;

  const CategorySearchBar({
    Key? key,
    required this.searchController,
    required this.parentDocId,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  State<CategorySearchBar> createState() => _CategorySearchBarState();
}

class _CategorySearchBarState extends State<CategorySearchBar> {
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              controller: widget.searchController,
              decoration: const InputDecoration(
                hintText: 'Search categories',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                final isSearching = value.isNotEmpty;
                setState(() {
                  _isSearching = isSearching;
                });
                widget.onSearchChanged(isSearching);

                // Cancel previous debounce timer if it exists
                if (_debounce?.isActive ?? false) {
                  _debounce!.cancel();
                }

                // Use debounce to avoid too many database calls
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  print("Searching for: '$value'");
                  if (value.isEmpty) {
                    // Reset to show all categories
                    context.read<CategoryBloc>().add(
                      FetchChildCategories(parentId: widget.parentDocId),
                    );
                  } else {
                    // Dispatch search event with the query value
                    context.read<CategoryBloc>().add(
                      SearchCategories(
                        parentId: widget.parentDocId,
                        query: value,
                      ),
                    );
                  }
                });
              },
            ),
          ),
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () {
                widget.searchController.clear();
                setState(() {
                  _isSearching = false;
                });
                widget.onSearchChanged(false);
                // Reset to show all categories
                context.read<CategoryBloc>().add(
                  FetchChildCategories(parentId: widget.parentDocId),
                );
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          // Show loading indicator when searching
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading && _isSearching) {
                return Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(4),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
