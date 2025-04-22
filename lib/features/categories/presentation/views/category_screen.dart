import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/categories/presentation/views/category_child_screen.dart';


import '../../../../core/di/di.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/assets_data.dart';
import '../../../../core/utils/widgets/custom_text_field.dart';
import '../controller/category_bloc.dart';
import '../controller/category_event.dart';
import '../controller/category_state.dart';
import '../widgets/category_card.dart';
import '../widgets/row_card.dart';
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc,CategoryState>(
      listener: (BuildContext context, CategoryState state) {  },
      builder: (BuildContext context, CategoryState state) {
        var bloc = context.read<CategoryBloc>();
        return SafeArea(
          child:  Padding(
            padding: const EdgeInsets.all(20),
            child: Column(

              children: [
                SizedBox(height: 60,),
                Center(
                  child: Text(
                    'ulmo',
                    style: AppTextStyle.heading1, // using your custom style
                  ),),
                SizedBox(height: 10,),

                CustomTextField(
                  hintText: 'Search',
                  prefixPath: Assets.iconsUlmoIcon,
                ),
                const SizedBox(height: 16),

                // The horizontal list of categories
                SizedBox(
                  height: 90,
                   child:  ConditionalBuilder(
                      condition: state is! CategoryLoading,
                      builder: (context) {
                        final categories = bloc.categories;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return FeaturedCategoryTile(
                              title: categories[index].name,
                              imageUrl: categories[index].imageUrl,
                            );
                          },
                          separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                        );
                      },
                      fallback: (context) {
                        if (state is CategoryError) {
                          return Center(child: Text('Error: ${state.message}'));
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    )
                ),
                SizedBox(height: 30,),
                ConditionalBuilder(
                  condition: bloc.categories.isNotEmpty,
                  builder: (context) {
                    return Expanded(
                      child: ListView.separated(
                        itemCount: bloc.categories.length,
                        itemBuilder: (context, index) {
                          final category = bloc.categories[index];
                          return MainCategoryTile(
                            title: category.name,
                            imageurl: category.imageUrl,
                            onTap: () {
                              print(category.id);
                              // bloc.add(FetchChildCategories(parentId: category.id));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider<CategoryBloc>(
                                    create: (_) => di<CategoryBloc>()..add(FetchChildCategories(parentId: category.id)),
                                    child: ParentCategoryScreen(
                                      parentDocId: category.id,
                                      parentTitle: category.name,
                                    ),
                                  ),
                                ),
                              );

                              print('Tapped on ${category.name}');
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                         SizedBox(height: 16),
                      ),
                    );
                  },
                  fallback: (context) =>  Expanded(
                    child: Center(
                      child: Text("No categories available"),
                    ),
                  ),
                ),              ],
            ),
          ),
        );

      },
    );
  }
}