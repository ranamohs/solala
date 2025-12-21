import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/functions/navigation.dart';
import 'package:solala/core/routes/app_router.dart' show AppRouter;
import 'package:solala/core/state_management/user_cubit/user_cubit.dart'
    show UserCubit;
import 'package:solala/core/state_management/user_cubit/user_state.dart';
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
    Future.delayed(const Duration(milliseconds:5), () {
      if (mounted) {
        context.read<UserCubit>().checkGuestStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            if (state.isGuest) {
              customGo(context, AppRouter.loginView);
            } else {
              customGo(context, AppRouter.loginView);
            }
          }
        });
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

