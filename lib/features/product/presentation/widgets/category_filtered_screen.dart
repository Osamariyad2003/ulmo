// CategoryFilterScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../controller/product_bloc.dart';
import '../controller/product_event.dart';
import '../controller/product_state.dart';
import 'filter_button.dart';

class CategoryFilterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Category', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => context.read<ProductBloc>().add(ClearSelectionEvent()),
            child: Text("Clear", style: TextStyle(color: Colors.black)),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => di<ProductBloc>()..add(LoadFilteredCategoriesEvent()),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded) {
              return Column(
                children: [
              Expanded(
              child: ListView.builder(
              itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  final isSelected = state.selectedCategories.contains(category);
                  return ListTile(
                    title: Text("${category.name}", style: TextStyle(fontSize: 16)),
                    trailing: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Colors.yellow[700] : Colors.grey,
                    ),
                    onTap: () => context.read<ProductBloc>().add(ToggleCategoryEvent(category as String)),
                  );
                },
              ),),
            FilterButton(
            itemCount: state.categories.length,
            onPressed: () {
            // Implement filter action
            },
            ),

            ],
            );
            } else if (state is CategoryError) {
            return Center(child: Text('Failed to load categories'));
            } else {
            return SizedBox.shrink();
            }
          },
        ),

      ),

    );

  }

}

