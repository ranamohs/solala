import 'package:solala/features/home/data/models/categories_models/categories_model.dart';
import 'package:solala/features/home/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoriesSliverGrid extends StatelessWidget {
  const CategoriesSliverGrid({super.key, required this.categories});

  final List<CategoryData> categories;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (context, index) => CategoryItem(
          category: categories[index],
        ),
        childCount: categories.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 2.2,
      ),
    );
  }
}


