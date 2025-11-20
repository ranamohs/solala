
import '../../../data/models/news_model/news_model.dart';

abstract class NewsState {}

class ReportsInitial extends NewsState {}

class ReportsLoading extends NewsState {}

class ReportsSuccess extends NewsState {
  final NewsModel reportModel;
  final Map<int, ReportData> reportDetails;
  final Set<int> loadingReports;
  final Map<int, String> errorReports;

  ReportsSuccess({
    required this.reportModel,
    this.reportDetails = const {},
    this.loadingReports = const {},
    this.errorReports = const {},
  });

  ReportsSuccess copyWith({
    NewsModel? reportModel,
    Map<int, ReportData>? reportDetails,
    Set<int>? loadingReports,
    Map<int, String>? errorReports,
  }) {
    return ReportsSuccess(
      reportModel: reportModel ?? this.reportModel,
      reportDetails: reportDetails ?? this.reportDetails,
      loadingReports: loadingReports ?? this.loadingReports,
      errorReports: errorReports ?? this.errorReports,
    );
  }
}

class ReportsFailure extends NewsState {
  final String message;

  ReportsFailure({required this.message});
}
