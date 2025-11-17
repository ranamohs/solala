import 'package:solala/features/home/data/models/categories_models/categories_model.dart';
import 'package:flutter/material.dart';

import 'category_item.dart';

class CategoriesGridView extends StatelessWidget {
  const CategoriesGridView({
    super.key,
    required this.categories,
    this.scrollController,
  });

  final List<CategoryData> categories;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 24,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryItem(
          category: categories[index],
        );
      },
    );
  }
}
