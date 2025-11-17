
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/state_management/user_cubit/user_cubit.dart';
import 'package:solala/core/widgets/fixit_app_bars.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/service_locator.dart';
import '../../data/models/shops_model.dart';
import '../manager/request_service_cubit/request_service_cubit.dart';
import '../manager/request_service_cubit/request_service_state.dart';
import '../widgets/service_info_card.dart';
import '../widgets/shop_gallery_section.dart';
import '../widgets/success_dialog.dart';

class ShopDetailView extends StatefulWidget {
  const ShopDetailView({super.key, required this.shopData});

  final ShopData shopData;

  @override
  State<ShopDetailView> createState() => _ShopDetailViewState();
}

class _ShopDetailViewState extends State<ShopDetailView> {
  @override
  Widget build(BuildContext context) {
    final bool isGuest =
    context.select<UserCubit, bool>((cubit) => cubit.state.isGuest);

    return Scaffold(
      appBar: PrimaryAppBar(title: AppStrings.serviceDetail.tr()),
      body: BlocProvider(
        create: (context) => getIt<RequestServiceCubit>(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              children: [
                ServiceImageGallery(shopData: widget.shopData),
                const VerticalSpace(12),
                BlocConsumer<RequestServiceCubit, RequestServiceState>(
                  listener: (context, state) {
                    if (state is SelectedServiceSuccessState) {
                      showDialog(
                        context: context,
                        builder: (context) => SuccessDialog(
                          onRateService: () {
                            Navigator.of(context).pop();
                            GoRouter.of(context).push(
                              AppRouter.rating,
                              extra: widget.shopData.id,
                            );
                          },
                        ),
                      );
                    }
                    if (state is SelectedServiceFailureState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.failure.errMessage)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is SelectedServiceLoadingState;
                    return ServiceInfoCard(
                      isLoading: isLoading,
                      shopData: widget.shopData,
                      isGuest: isGuest,
                      onRequestService: () {
                          context.read<RequestServiceCubit>().selectedService(
                            shopId: widget.shopData.id,
                          );
                        }

                    );
                  },
                ),
                const VerticalSpace(18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}