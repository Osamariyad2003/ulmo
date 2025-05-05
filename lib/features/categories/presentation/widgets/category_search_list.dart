import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/di/di.dart';
import 'package:ulmo/features/product/presentation/controller/product_bloc.dart';
import 'package:ulmo/features/product/presentation/controller/product_event.dart';
import 'package:ulmo/features/product/presentation/views/product_screen.dart';

class CategorySearchResultsList extends StatelessWidget {
  final List<dynamic> results;

  const CategorySearchResultsList({Key? key, required this.results})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        try {
          final category = results[index];
          print("Rendering search result ${index}: ${category.name}");
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.category),
              title: Text(category.name ?? "Category"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider<ProductBloc>(
                          create:
                              (_) =>
                                  di<ProductBloc>()
                                    ..add(LoadProductsEvent(category.id)),
                          child: ProductScreen(
                            parentid: category.id,
                            parentCategory: category.name,
                          ),
                        ),
                  ),
                );
              },
            ),
          );
        } catch (e) {
          print("Error rendering item at index $index: $e");
          return ListTile(title: Text("Error displaying item"));
        }
      },
    );
  }
}
