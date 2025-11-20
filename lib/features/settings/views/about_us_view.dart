import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/functions/is_arabic.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/widgets/error_container.dart';
import '../../../core/widgets/fixed_app_bars.dart';
import '../../app_info/presentation/manager/about_us_cubit/about_us_cubit.dart';
import '../../app_info/presentation/manager/about_us_cubit/about_us_state.dart';


class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  String _htmlToPlain(String? html) {
    if (html == null) return '';

    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'&nbsp;?', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AboutUsCubit>()..fetchAboutUs(),
      child: BlocBuilder<AboutUsCubit, AboutUsState>(
        builder: (context, state) {
          String appBarTitle = '...';
          Widget body = const SizedBox.shrink();

          if (state is AboutUsLoadingState) {
            body =      Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: AppColors.primaryColor,
                rightDotColor: AppColors.greenColor,
                size: 64,
              ),
            );;
          } else if (state is AboutUsCachedLoadingState) {
            final info = state.cachedData;
            final isAr = isArabic(context);
            final name = isAr ? info.data?.name?.ar : info.data?.name?.en;
            final rawBody = isAr ? info.data?.body?.ar : info.data?.body?.en;
            final plain = _htmlToPlain(rawBody);

            appBarTitle = (name ?? '').trim().isEmpty ? '...' : name!;
            body = Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async =>
                      context.read<AboutUsCubit>().fetchAboutUs(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? '...',
                            style: AppStyles.styleBold20(context).copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            plain.isNotEmpty
                                ? plain
                                : (isAr ? 'لا توجد بيانات' : 'No Data'),
                            textAlign: TextAlign.start,
                            style: AppStyles.styleMedium18(
                              context,
                            ).copyWith(color: AppColors.secondaryColor ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AboutUsFailureState) {
            appBarTitle = '';
            body = Center(
              child: ErrorContainer(
                message: state.message.isNotEmpty
                    ? state.message
                    : (isArabic(context)
                    ? 'حدث خطأ غير متوقع'
                    : 'Unexpected error'),
              ),
            );
          } else if (state is AboutUsSuccessState) {
            final info = state.info;
            final isAr = isArabic(context);

            final name = isAr ? info.data?.name?.ar : info.data?.name?.en;
            final rawBody = isAr ? info.data?.body?.ar : info.data?.body?.en;
            final plain = _htmlToPlain(rawBody);

            appBarTitle = (name ?? '').trim().isEmpty ? '...' : name!;
            body = RefreshIndicator(
              onRefresh: () async =>
                  context.read<AboutUsCubit>().fetchAboutUs(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        plain.isNotEmpty
                            ? plain
                            : (isAr ? 'لا توجد بيانات' : 'No Data'),
                        textAlign: TextAlign.start,
                        style: AppStyles.styleMedium22(
                          context,
                        ).copyWith(color: AppColors.greyColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(

            body: Center(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                  decoration:  BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.homeBackground), fit: BoxFit.cover,
                    ),
                  ),

                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          HomePageAppBar(
                            title: appBarTitle,
                            leading: IconButton(
                              icon:  Icon(Icons.arrow_back_ios, color: AppColors.secondaryColor),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          body
                        ],
                      ),
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );
  }
}