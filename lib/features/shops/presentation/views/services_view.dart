import 'package:solala/core/functions/is_arabic.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/core/widgets/spacing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/fixit_app_bars.dart';
import '../manager/shops_cubit/shops_cubit.dart';
import '../widgets/services_list_view_section.dart';

class ShopsView extends StatelessWidget {
  const ShopsView(
      {super.key,
      required this.categoryId,
      required this.categoryArName,
      required this.categoryEnName});

  final int categoryId;
  final String categoryArName;
  final String categoryEnName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimaryAppBar(
            title: isArabic(context) ? categoryArName : categoryEnName),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              VerticalSpace(16),
              Expanded(
                  child: BlocProvider(
                      create: (context) =>
                      getIt<ShopsCubit>()..getShops(categoryId: categoryId),
                      child: ShopsListViewSection(categoryId: categoryId))),

            ],
          ),
        ));
  }
}
