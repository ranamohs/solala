import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../search/presentation/manager/search_cubit.dart';
import '../../../search/presentation/manager/search_state.dart';
import '../manager/recent_shops_cubit/recent_shops_cubit.dart';
import '../manager/recent_shops_cubit/recent_shops_state.dart';
import '../widgets/all_recent_shops_grid_view.dart';
import '../widgets/shops_grid_view.dart';

class AllRecentShopsView extends StatefulWidget {
  const AllRecentShopsView({Key? key}) : super(key: key);

  @override
  State<AllRecentShopsView> createState() => _AllRecentShopsViewState();
}

class _AllRecentShopsViewState extends State<AllRecentShopsView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<RcenetShopsCubit>().getRcenetShops();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    setState(() {});
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        context.read<ShopsSearchCubit>().searchShops(_searchController.text);
      } else {
        context.read<ShopsSearchCubit>().resetSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.allShops.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.splashBackgroundStart.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12.0),

                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppStrings.searchForShops.tr(),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

              ],
            ),

            Expanded(
              child: _searchController.text.isEmpty
                  ? BlocBuilder<RcenetShopsCubit, RcenetShopsState>(
                builder: (context, state) {
                  if (state is RcenetShopsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RcenetShopsSuccess) {
                    return AllRecentShopsGridView(
                        categories: state.categoriesModel.data);
                  } else if (state is RcenetShopsFailure) {
                    return Center(child: Text(state.failure.errMessage));
                  }
                  return Center(
                      child:  Text(AppStrings.noRecentShopsFound.tr()));
                },
              )
                  : BlocBuilder<ShopsSearchCubit, ShopsSearchState>(
                builder: (context, state) {
                  if (state is ShopsSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ShopsSearchSuccess) {
                    if (state.shopsModel.data.isEmpty) {
                      return Center(
                          child:  Text(AppStrings.noShopsFoundMatchingYourSearch .tr())
                             );
                    }
                    return ShopsGridView(shops: state.shopsModel.data);
                  } else if (state is ShopsSearchFailure) {
                    return Center(child: Text(state.failure.errMessage));
                  }
                  return Center(
                      child:  Text(AppStrings.searchForSomthing.tr()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}