import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/features/events/presentation/manager/events_cuibt/events_cubit.dart';
import 'package:solala/features/home/presentation/views/home_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:upgrader/upgrader.dart';
import 'package:solala/core/services/update_service.dart';
import 'package:flutter/material.dart';
import '../../../account/presentation/views/update_profile_view.dart';
import '../../../events/presentation/views/events_view.dart';
import '../../../family_tree/presentation/manager/family_cubit/family_cubit.dart';
import '../../../family_tree/presentation/views/family_tree_view.dart';
import '../../../settings/views/settings_view.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late final EventsCubit _eventsCubit;
  late final FamilyTreeCubit _familyTreeCubit;

  @override
  void initState() {
    super.initState();
    _eventsCubit = getIt<EventsCubit>();
    _familyTreeCubit = getIt<FamilyTreeCubit>();
    getIt<UpdateService>().checkForUpdates();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      _eventsCubit.getEvents();
    } else if (index == 2) {
      _familyTreeCubit.getFamilyTree();
    }
  }

  void _onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeView(),
      const EventsView(),
      const FamilyTreeView(),
      const SettingsView(),
      const UpdateProfileView(),
    ];
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _eventsCubit),
        BlocProvider.value(value: _familyTreeCubit),
      ],
      child: UpgradeAlert(
        upgrader: Upgrader(
          debugLogging: true,
          durationUntilAlertAgain: const Duration(hours: 1),
          // Only show Upgrader alert if we are on iOS,
          // or if on Android and you want it as a fallback.
          // Since the user is complaining it's not showing on Android,
          // let's ensure it's not restricted.
        ),
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.bottomColor,
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: AppStyles.styleMedium10(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: AppStyles.styleMedium10(context),
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.lightGreyColor,
            items: [
              _buildNavItem(
                iconPath: AppAssets.homeIcon,
                label: AppStrings.home.tr(),
                isSelected: _currentIndex == 0,
              ),
              _buildNavItem(
                iconPath: AppAssets.eventsIcon,
                label: AppStrings.events.tr(),
                isSelected: _currentIndex == 1,
              ),
              _buildNavItem(
                iconPath: AppAssets.treeImage,
                label: AppStrings.familyTree.tr(),
                isSelected: _currentIndex == 2,
              ),
              _buildNavItem(
                iconPath: AppAssets.settingsIcon,
                label: AppStrings.settings.tr(),
                isSelected: _currentIndex == 3,
              ),
              _buildNavItem(
                iconPath: AppAssets.accountIcon,
                label: AppStrings.myAccount.tr(),
                isSelected: _currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        iconPath,
        height: 24,
        color: isSelected ? AppColors.primaryColor : AppColors.greenColor,
      ),
      label: label,
    );
  }
}
