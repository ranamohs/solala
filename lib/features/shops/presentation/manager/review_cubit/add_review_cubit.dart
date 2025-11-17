import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repos/review/add_review_repo.dart';
import 'add_review_state.dart';

class AddReviewCubit extends Cubit<AddReviewState> {
  final AddReviewRepo addReviewRepo;

  AddReviewCubit({required this.addReviewRepo}) : super(AddReviewInitial());

  Future<void> addReview({
    required int shopId,
    required int rating,
    required String comment,
  }) async {
    emit(AddReviewLoading());
    final result = await addReviewRepo.addReview(
      shopId: shopId,
      rating: rating,
      comment: comment,
    );
    result.fold(
          (failure) => emit(AddReviewFailure(failure)),
          (_) => emit(AddReviewSuccess()),
    );
  }
}