import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/news_model/news_model.dart';
import '../../../data/repos/news_repos/news_repo.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit(this.reportsRepo) : super(ReportsInitial());

  final NewsRepo reportsRepo;

  Future<void> getReports() async {
    emit(ReportsLoading());
    final result = await reportsRepo.getReports();
    result.fold(
          (failure) => emit(ReportsFailure(message: failure.errMessage)),
          (reportModel) => emit(ReportsSuccess(reportModel: reportModel)),
    );
  }

  Future<void> getReportDetails(int reportId) async {
    if (state is ReportsSuccess) {
      final successState = state as ReportsSuccess;
      emit(
        successState.copyWith(
          loadingReports: {...successState.loadingReports, reportId},
          errorReports: {...successState.errorReports}..remove(reportId),
        ),
      );
      final result = await reportsRepo.getReportDetails(reportId);
      result.fold(
            (failure) {
          emit(
            successState.copyWith(
              loadingReports: {...successState.loadingReports}..remove(reportId),
              errorReports: {...successState.errorReports, reportId: failure.errMessage},
            ),
          );
        },
            (reportDetailsModel) {
          emit(
            successState.copyWith(
              loadingReports: {...successState.loadingReports}..remove(reportId),
              reportDetails: {...successState.reportDetails, reportId: reportDetailsModel.data!},
            ),
          );
        },
      );
    }
  }

  Future<void> createNews(CreateNewsRequestModel createNewsRequestModel) async {
    emit(CreateNewsLoading());
    final result = await reportsRepo.createNews(createNewsRequestModel);
    result.fold(
          (failure) => emit(CreateNewsError(message: failure.errMessage)),
          (_) {
        emit(CreateNewsSuccess(message: 'News Created Successfully'));
        getReports();
      },
    );
  }
}
