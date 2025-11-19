import 'package:solala/core/functions/internet_connection_status_snack_bar.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_state.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/home/presentation/manager/banners_cubit/banners_cubit.dart';
import 'package:solala/features/home/presentation/widgets/banners_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/fixed_indicators.dart';
import '../widgets/events_section.dart';
import '../widgets/home_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Container(
      decoration: BoxDecoration(
       image: DecorationImage(
         image: AssetImage(AppAssets.homeBackground),
         fit: BoxFit.cover,
       ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: isArabic ? const HomeDrawer() : null,
        drawer: !isArabic ? const HomeDrawer() : null,
        body: BlocListener<NetworkConnectionCubit, NetworkConnectionState>(
          listener: (context, state) {
            if (state is NetworkConnected) {
              internetConnectionStatusSnackBar(context, isConnected: true);
            } else if (state is NetworkDisconnected) {
              internetConnectionStatusSnackBar(context, isConnected: false);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
            child: PrimaryRefreshIndicator(
              onRefresh: () async {
                context.read<BannersCubit>().getBanners();

              },
              child: CustomScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpace(22),
                        HomeAppbar(
                          isArabic: isArabic,
                        ),
                        VerticalSpace(22),
                      ],
                    ),
                  ),
                  const BannersSection(),
                  const SliverToBoxAdapter(child:VerticalSpace(40)),
                  SliverToBoxAdapter(child: EventsSection()),
                  // SliverToBoxAdapter(
                  //   child: Column(
                  //     children: [
                  //       VerticalSpace(24),
                  //       TitleAndViewAll(
                  //         title: AppStrings.categories.tr(),
                  //         viewAllText: AppStrings.viewAll.tr(),
                  //         onPressed: () {
                  //           GoRouter.of(context).push(AppRouter.allCategoriesView);
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // BlocBuilder<CategoriesCubit, CategoriesState>(
                  //   builder: (context, state) {
                  //     if (state is CategoriesLoading) {
                  //       return SliverSkeletonizer(
                  //         child: CategoriesSliverGrid(
                  //           categories: getDummyCategories().take(4).toList(),
                  //         ),
                  //       );
                  //     }
                  //     if (state is CategoriesSuccess) {
                  //       final categories = state.categoriesModel.data;
                  //       if (categories.isEmpty) {
                  //         return const SliverToBoxAdapter(child: SizedBox.shrink());
                  //       }
                  //       final displayedCategories = categories.take(4).toList();
                  //       return CategoriesSliverGrid(
                  //         categories: displayedCategories,
                  //       );
                  //     } else if (state is CategoriesFailure) {
                  //       return SliverToBoxAdapter(
                  //         child: Center(child: Text(state.failure.errMessage)),
                  //       );
                  //     } else {
                  //       return const SliverToBoxAdapter(child: SizedBox.shrink());
                  //     }
                  //   },
                  // ),
                  // SliverToBoxAdapter(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       TitleAndViewAll(
                  //         title: AppStrings.recentShops.tr(),
                  //         viewAllText: AppStrings.viewAll.tr(),
                  //         onPressed: () {
                  //           GoRouter.of(context)
                  //               .push(AppRouter.allRecentShopsView);
                  //         },
                  //       ),
                  //       const RecentShopsListViewSection(),
                  //       SizedBox(
                  //         height: 24.h,
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}