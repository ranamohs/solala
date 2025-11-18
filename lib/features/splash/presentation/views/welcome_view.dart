import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/databases/cache/app_data_manager.dart';
import 'package:solala/core/databases/cache/cache_helper.dart';
import 'package:solala/core/functions/navigation.dart';
import 'package:solala/core/routes/app_router.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_buttons.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  String selectedLanguage = 'ar';
  final CacheHelper _cacheHelper = getIt<CacheHelper>();

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLanguage = await _cacheHelper.getData(key: 'language');
    if (savedLanguage != null) {
      setState(() {
        selectedLanguage = savedLanguage;
        context.setLocale(Locale(savedLanguage));
      });
    }
  }

  Future<void> saveLanguage(String languageCode) async {
    await _cacheHelper.saveData(key: 'language', value: languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            AppAssets.chooseLanguageBg,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.splashColor,
                    AppColors.white,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(flex: 1),

                      // Logo
                      Image.asset(
                        AppAssets.appLogo,
                        width: 109.w,
                        height: 109.h,
                      ),
                      SizedBox(height: 16.h),

                      // Title
                      Text(
                        AppStrings.selectYourLanguage.tr(),
                        style: AppStyles.styleSemiBold24(context),
                      ),
                      SizedBox(height: 22.h),

                      // English Language Button
                      LanguageButton(
                        flagAsset: AppAssets.englishImage,
                        languageName: 'English',
                        isSelected: selectedLanguage == 'en',
                        flagWidth: 28.w,
                        flagHeight: 28.h,
                        isFlagImage: true,
                        onTap: () {
                          setState(() {
                            selectedLanguage = 'en';
                            context.setLocale(const Locale('en'));
                            saveLanguage('en');
                          });
                        },
                      ),

                      SizedBox(height: 8.h),

                      // Arabic Language Button
                      LanguageButton(
                        flagAsset: AppAssets.arabicImage,
                        languageName: 'العربية',
                        isSelected: selectedLanguage == 'ar',
                        flagWidth: 24.w,
                        flagHeight: 24.h,
                        isFlagImage: true,
                        onTap: () {
                          setState(() {
                            selectedLanguage = 'ar';
                            context.setLocale(const Locale('ar'));
                            saveLanguage('ar');
                          });
                        },
                      ),

                      Spacer(flex: 2),

                      PrimaryButton(
                        text: AppStrings.letsGo.tr(),
                        onPressed: () {
                          final appDataManager = getIt<AppDataManager>();
                          appDataManager.saveIsSelectLanguageViewVisited(
                            isSelectLanguageViewVisited: true,
                          );
                          customPushReplacement(context, AppRouter.introView);
                        },
                      ),

                      SizedBox(height: 22.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}