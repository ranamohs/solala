import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart' show AppColors;
import 'package:solala/core/databases/cache/app_data_manager.dart'
    show AppDataManager;
import 'package:solala/core/functions/navigation.dart';
import 'package:solala/core/routes/app_router.dart' show AppRouter;
import 'package:solala/core/services/service_locator.dart' show getIt;
import 'package:solala/core/state_management/user_cubit/user_cubit.dart'
    show UserCubit;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    _checkUserStatusAndNavigate();
  }



Future<void> _checkUserStatusAndNavigate() async {
  final userCubit = context.read<UserCubit>();
  await userCubit.checkGuestStatus();

  Future.delayed(const Duration(seconds: 5), () {
    if (!mounted) return;
    if (userCubit.state.isGuest) {
      customGo(context, AppRouter.loginView);
    } else {
      customGo(context, AppRouter.loginView);
    }
  }
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.splashBackground),
            fit: BoxFit.cover,
          ),
        ),

      ),
    );
  }
}