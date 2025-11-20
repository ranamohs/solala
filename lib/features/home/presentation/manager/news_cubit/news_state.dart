
import '../../../data/models/news_model/news_model.dart';

abstract class NewsState {}

class ReportsInitial extends NewsState {}

class ReportsLoading extends NewsState {}

class ReportsSuccess extends NewsState {
  final NewsModel reportModel;

  ReportsSuccess({required this.reportModel});
}

class ReportsFailure extends NewsState {
  final String message;

  ReportsFailure({required this.message});
}
