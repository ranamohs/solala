import 'package:solala/features/home/data/models/categories_models/categories_model.dart';
import 'package:solala/features/home/presentation/widgets/category_card.dart';
import 'package:flutter/material.dart';

class AllRecentShopsGridView extends StatelessWidget {
  const AllRecentShopsGridView({
    super.key,
    required this.categories,
  });

  final List<CategoryData> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) => CategoryCard(categoryModel: categories[index]),
    );
  }
}