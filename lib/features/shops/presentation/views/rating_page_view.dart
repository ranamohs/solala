import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/services/service_locator.dart';


import '../../../../core/constants/app_strings.dart';
import '../../../../core/functions/navigation.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/fixit_buttons.dart';
import '../manager/review_cubit/add_review_cubit.dart';
import '../manager/review_cubit/add_review_state.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key, required this.shopId});
  final int shopId;

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 0;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFE8D5F2).withOpacity(0.6),
                  const Color(0xFFC9E4F5).withOpacity(0.6),
                  const Color(0xFFE0F5F0).withOpacity(0.6),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [

                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w, top: 8.h),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey.shade600,
                          size: 24.sp,
                        ),
                        onPressed: () => customGo(context, AppRouter.homePage),
                        padding: EdgeInsets.all(8.w),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 40.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title
                          Text(
                            AppStrings.enjoyYourExperience.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4DBBA8),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Subtitle
                          Text(
                            AppStrings.leaveARating.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF7BC9BD),
                            ),
                          ),
                          SizedBox(height: 48.h),
                          // Rating stars - outline style
                          Center(
                            child: RatingBar.builder(
                              initialRating: 0,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                              ),
                              itemBuilder: (context, index) =>
                                  Icon(Icons.star, color: Colors.amberAccent),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _rating = rating;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 48.h),
                          // Feedback text field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _commentController,
                              maxLines: 5,
                              style: TextStyle(fontSize: 14.sp),
                              decoration: InputDecoration(
                                hintText: AppStrings.leaveAFeedback.tr(),
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade400,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(16.w),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          // Submit button
                          BlocProvider(
                            create: (context) => AddReviewCubit(addReviewRepo: getIt()),
                            child: BlocConsumer<AddReviewCubit, AddReviewState>(
                              listener: (context, state) {
                                if (state is AddReviewSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppStrings.ratingAddedSuccessfully.tr()),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  customGo(context, AppRouter.homePage);
                                } else if (state is AddReviewFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.failure.errMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is AddReviewLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                return PrimaryButton(
                                  onPressed: () {
                                    context.read<AddReviewCubit>().addReview(
                                      shopId: widget.shopId,
                                      rating: _rating.toInt(),
                                      comment: _commentController.text,
                                    );
                                  },
                                  text: AppStrings.submit.tr(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
