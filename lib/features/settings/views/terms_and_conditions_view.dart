import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/functions/is_arabic.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/fixed_app_bars.dart';
import '../../../../core/widgets/error_container.dart';
import '../../../core/constants/app_assets.dart';
import '../../app_info/presentation/manager/terms_cubit/terms_cubit.dart';
import '../../app_info/presentation/manager/terms_cubit/terms_state.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

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
      create: (_) => getIt<TermsCubit>()..fetchTerms(),
      child: BlocBuilder<TermsCubit, TermsState>(
        builder: (context, state) {
          String appBarTitle = '...';
          Widget body = const SizedBox.shrink();

          if (state is TermsLoadingState) {
            body = Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: AppColors.primaryColor,
                rightDotColor: AppColors.greenColor,
                size: 64,
              ),
            );
          } else if (state is TermsCachedLoadingState) {
            final info = state.cachedData;
            final isAr = isArabic(context);
            final name = isAr ? info.data?.name?.ar : info.data?.name?.en;
            final raw = isAr ? info.data?.body?.ar : info.data?.body?.en;
            final text = _htmlToPlain(raw);

            appBarTitle = (name ?? '').trim().isEmpty ? '...' : name!;
            body = Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async =>
                      context.read<TermsCubit>().fetchTerms(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Text(
                      text.isNotEmpty
                          ? text
                          : (isAr ? 'لا توجد بيانات' : 'No Data'),
                      textAlign: TextAlign.start,
                      style: AppStyles.styleMedium18(
                        context,
                      ).copyWith(color: AppColors.greyColor),
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
          }
          // ===== Failure =====
          else if (state is TermsFailureState) {
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
          }
          // ===== Success =====
          else if (state is TermsSuccessState) {
            final info = state.info;
            final isAr = isArabic(context);
            final name = isAr ? info.data?.name?.ar : info.data?.name?.en;
            final raw = isAr ? info.data?.body?.ar : info.data?.body?.en;
            final text = _htmlToPlain(raw);

            appBarTitle = (name ?? '').trim().isEmpty ? '...' : name!;
            body = RefreshIndicator(
              onRefresh: () async => context.read<TermsCubit>().fetchTerms(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Text(
                  text.isNotEmpty
                      ? text
                      : (isAr ? 'لا توجد بيانات' : 'No Data'),
                  textAlign: TextAlign.start,
                  style: AppStyles.styleMedium22(
                    context,
                  ).copyWith(color: AppColors.greyColor),
                ),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.homeBackground),
                    fit: BoxFit.cover,
                  ),
                ),

                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HomePageAppBar(
                          title: appBarTitle,
                          leading: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.secondaryColor,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        body,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
