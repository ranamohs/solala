
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/databases/cache/cache_helper.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/widgets/fixed_app_bars.dart';
import '../../../core/widgets/language_selection_tile.dart';
import '../../../core/widgets/spacing.dart';

class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({super.key});

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeBackground),
          fit: BoxFit.cover,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:AppBar(
          title: Text(
            AppStrings.changeLanguage.tr(),
            style: AppStyles.styleMedium22(context),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              Text(
                AppStrings.selectYourLanguage.tr(),
                style: AppStyles.styleLight20(context),
              ),
             Spacer(flex: 1),
              LanguageSelectionTile(
                groupValue: selectedLanguage,
                onChangEnglish: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLanguage = value;
                      context.setLocale(const Locale('en'));
                      saveLanguage('en');
                    });
                  }
                },
                onChangArabic: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLanguage = value;
                      context.setLocale(const Locale('ar'));
                      saveLanguage('ar');
                    });
                  }
                },
              ),
              Spacer(flex: 8),
            ],
          ),
        ),
      ),
    );
  }
}
