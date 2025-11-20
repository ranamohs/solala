import 'package:flutter_bloc/flutter_bloc.dart';

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
}
