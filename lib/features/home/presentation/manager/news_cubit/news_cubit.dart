import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repos/news_repos/news_repo.dart';
import 'news_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this.reportsRepo) : super(ReportsInitial());

  final ReportsRepo reportsRepo;

  Future<void> getReports() async {
    emit(ReportsLoading());
    final result = await reportsRepo.getReports();
    result.fold(
          (failure) => emit(ReportsFailure(message: failure.errMessage)),
          (reportModel) => emit(ReportsSuccess(reportModel: reportModel)),
    );
  }
}
