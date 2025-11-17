import 'package:solala/features/shops/data/models/shops_model.dart';
import 'package:solala/features/home/presentation/widgets/shop_card.dart';
import 'package:flutter/material.dart';

class ShopsGridView extends StatelessWidget {
  const ShopsGridView({
    super.key,
    required this.shops,
  });

  final List<ShopData> shops;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: shops.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) => ShopCard(shop: shops[index]),
    );
  }
}