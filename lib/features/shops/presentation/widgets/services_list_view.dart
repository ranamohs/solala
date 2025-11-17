import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/shops/presentation/widgets/category_shops.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/shops_model.dart';

class ServicesListView extends StatelessWidget {
  const ServicesListView({
    super.key,
    required this.services,
    this.scrollController,
  });

  final List<ShopData> services;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: services.length,
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ServiceTile(
          shopData: services[index],
        );
      }, separatorBuilder: (BuildContext context, int index) {
        return  SizedBox(height: 26.h);
    },
    );
  }
}