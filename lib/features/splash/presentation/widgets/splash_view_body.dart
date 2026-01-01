import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/databases/cache/cache_helper.dart';
import 'package:solala/core/functions/navigation.dart';
import 'package:solala/core/routes/app_router.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/core/state_management/user_cubit/user_cubit.dart';
import 'package:solala/core/state_management/user_cubit/user_state.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Keep splash screen visible
    if (!mounted) return;

    final cacheHelper = getIt<CacheHelper>();
    bool isFirstTime = cacheHelper.getData(key: 'isFirstTime') ?? true;

    if (isFirstTime) {
      await cacheHelper.saveData(key: 'isFirstTime', value: false);
      customGo(context, AppRouter.loginView);
    } else {
      // It's not the first time, check login status
      // We trigger the check and listen for the result.
      context.read<UserCubit>().checkGuestStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      // This listener will trigger only when checkGuestStatus() is called.
      listener: (context, state) {
        // Ensure we don't navigate away if it was the first time
        final cacheHelper = getIt<CacheHelper>();
        bool isFirstTime = cacheHelper.getData(key: 'isFirstTime') ?? true;

        if (!isFirstTime) { // Only navigate based on auth state if it's not the first launch
          if (state.isGuest) {
            customGo(context, AppRouter.loginView);
          } else {
            customGo(context, AppRouter.homePage);
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.splashBackground),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
