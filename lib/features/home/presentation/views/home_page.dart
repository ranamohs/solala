import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/features/home/presentation/views/home_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../account/presentation/views/update_profile_view.dart';
import '../../../app_info/presentation/views/contact_us_view.dart';
import '../../../settings/views/settings_view.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const HomeView(),
    const SettingsView(),
    const ContactUsView(),
    const UpdateProfileView(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.splashBackgroundStart.withOpacity(0.9),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.lightGreyColor,
        items: [
          _buildNavItem(
            iconPath: AppAssets.homeIcon,
            label: AppStrings.home.tr(),
            isSelected: _currentIndex == 0,
          ),
          _buildNavItem(
            iconPath: AppAssets.settingsIcon,
            label: AppStrings.settings.tr(),
            isSelected: _currentIndex == 1,
          ),
          _buildNavItem(
            iconPath: AppAssets.supportIcon ,
            label: AppStrings.helpAndSupport.tr(),
            isSelected: _currentIndex == 2,
          ),
          _buildNavItem(
            iconPath: AppAssets.accountIcon,
            label: AppStrings.myAccount.tr(),
            isSelected: _currentIndex == 3,
          ),
        ],
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
        // colorFilter: ColorFilter.mode(
        //   isSelected ? AppColors.primaryColor : AppColors.lightGreyColor,
        //   BlendMode.srcIn,
        // ),
      ),
      label: label,
    );
  }
}