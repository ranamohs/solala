
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/functions/is_arabic.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/widgets/fixit_app_bars.dart';
import '../../../core/widgets/error_container.dart';
import '../../app_info/presentation/manager/privacy_cubit/privacy_cubit.dart';
import '../../app_info/presentation/manager/privacy_cubit/privacy_state.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

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
      create: (_) => getIt<PrivacyCubit>()..fetchPrivacy(), // ✅
      child: BlocBuilder<PrivacyCubit, PrivacyState>(
        builder: (context, state) {
          String appBarTitle = '...';
          Widget body = const SizedBox.shrink();

          // ===== Loading / CachedLoading =====
          if (state is PrivacyLoadingState) {
            body = Center(
              child:CircularProgressIndicator()
            );
          } else if (state is PrivacyCachedLoadingState) {
            final info = state.cachedData;
            final isAr = isArabic(context);
            final name = isAr ? info.data?.name?.ar : info.data?.name?.en;
            final raw  = isAr ? info.data?.body?.ar : info.data?.body?.en;
            final text = _htmlToPlain(raw);

            appBarTitle = (name ?? '').trim().isEmpty ? '...' : name!;
            body = Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async => context.read<PrivacyCubit>().fetchPrivacy(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                    child: Text(
                      text.isNotEmpty ? text : (isAr ? 'لا توجد بيانات' : 'No Data'),
                      textAlign: TextAlign.start,
                      style: AppStyles.styleMedium18(context)
                          .copyWith(color: AppColors.greyColor),
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
                          height: 28, width: 28,
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
          else if (state is PrivacyFailureState) {
            appBarTitle = '';
            body = Center(
              child: ErrorContainer(
                message: state.message.isNotEmpty
                    ? state.message
                    : (isArabic(context) ? 'حدث خطأ غير متوقع' : 'Unexpected error'),
                // onRetry: () => context.read<PrivacyCubit>().fetchPrivacy(), // لو مدعوم
              ),
            );
          }

          // ===== Success =====
          else if (state is PrivacySuccessState) {
            final info = state.info;
            final isAr = isArabic(context);
            final name = isAr ? info.data?.name?.ar : info.data?.name?.en;
            final raw  = isAr ? info.data?.body?.ar : info.data?.body?.en;
            final text = _htmlToPlain(raw);

            appBarTitle = (name ?? '').trim().isEmpty ? '...' : name!;
            body = RefreshIndicator(
              onRefresh: () async => context.read<PrivacyCubit>().fetchPrivacy(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                child: Text(
                  text.isNotEmpty ? text : (isAr ? 'لا توجد بيانات' : 'No Data'),
                  textAlign: TextAlign.start,
                  style: AppStyles.styleMedium22(context)
                      .copyWith(color: AppColors.greyColor),
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
                      image: AssetImage(AppAssets.settingsBackground), fit: BoxFit.cover,
                    ),
                ),

                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          HomePageAppBar(
                            title: appBarTitle,
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
