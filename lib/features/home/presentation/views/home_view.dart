import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/core/functions/internet_connection_status_snack_bar.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_state.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/home/presentation/manager/banners_cubit/banners_cubit.dart';
import 'package:solala/features/home/presentation/manager/family_info_cubit/family_info_cubit.dart';
import 'package:solala/features/home/presentation/widgets/banners_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:solala/features/home/presentation/widgets/family_news_section.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/fixed_indicators.dart';
import '../manager/news_cubit/news_cubit.dart';
import '../manager/numering_events_cubit/numbering_events_cubit.dart';
import '../widgets/about_family_section.dart';
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
  void initState() {
    super.initState();
    _getFamilyInfo();
  }

  Future<void> _getFamilyInfo() async {
    final familyId = getIt<UserDataManager>().getUserFamilyId();
    if (familyId != null) {
      context.read<FamilyInfoCubit>().getFamilyInfo(familyId: familyId);
    }
  }

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
                context.read<NumberingEventsCubit>().getNumberingEvents();
                context.read<FamilyInfoCubit>().getFamilyInfo(familyId: getIt<UserDataManager>().getUserFamilyId()!);
                context.read<NewsCubit>().getReports();

              },
              child: CustomScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
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
                  const SliverToBoxAdapter(child: VerticalSpace(40)),
                  SliverToBoxAdapter(child: EventsSection()),
                  // إضافة AboutFamilySection هنا
                  const SliverToBoxAdapter(child: VerticalSpace(24)),
                  const SliverToBoxAdapter(
                    child: AboutFamilySection(),
                  ),
                  const SliverToBoxAdapter(child: VerticalSpace(24)),
                  SliverToBoxAdapter(
                    child: BlocProvider(
                      create: (context) => getIt<NewsCubit>(),
                      child: const FamilyNewsSection(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}