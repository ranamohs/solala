
import '../../../data/models/news_model/news_model.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsSuccess extends ReportsState {
  final ReportModel reportModel;

  ReportsSuccess({required this.reportModel});
}

class ReportsFailure extends ReportsState {
  final String message;

  ReportsFailure({required this.message});
}
