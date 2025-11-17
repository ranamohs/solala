import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/state_management/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit.dart';
import 'package:solala/core/widgets/back_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({super.key, required this.title, this.backgroundColor , this.actions});
  final String title;
  final Color? backgroundColor;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackIconButton(),
      backgroundColor: backgroundColor ?? AppColors.pureWhiteColor,
      titleSpacing: -1,
      title: FittedBox(
        child: Text(
          title,
          style: AppStyles.styleSemiBold18(context),
        ),
      ),
      scrolledUnderElevation: 0,
      actions: actions ?? [],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar(
      {super.key,  this.title, this.actions, this.leading});

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: leading ??
          IconButton(
              onPressed: () {

                context.read<BottomNavigationBarCubit>().changeIndex(0);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryColor,
              )),
      title: Text(
        title ?? '',
        style: AppStyles.styleBold18(context),
      ),
      titleSpacing: -12,
      scrolledUnderElevation: 0,
      elevation: 0,
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
