import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/home/data/models/categories_models/categories_model.dart';
import 'package:solala/features/home/presentation/widgets/category_card.dart';
import 'package:flutter/material.dart';

class RecentShopsListView extends StatelessWidget {
  const RecentShopsListView({
    super.key,
    required this.categories,
  });

  final List<CategoryData> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => const HorizontalSpace(12),
        itemBuilder: (context, index) => AspectRatio(
            aspectRatio: 0.8,
            child: CategoryCard(categoryModel: categories[index])),
      ),
    );
  }
}
