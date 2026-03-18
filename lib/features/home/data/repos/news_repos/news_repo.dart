import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../models/news_model/news_model.dart';

abstract class NewsRepo {
  Future<Either<Failure, NewsModel>> getReports();
  Future<Either<Failure, NewsDetailsModel>> getReportDetails(int reportId);
  Future<Either<Failure, void>> createNews(
      CreateNewsRequestModel createNewsRequestModel);
  Future<Either<Failure, void>> updateNews(
      int reportId, CreateNewsRequestModel updateNewsRequestModel);
  Future<Either<Failure, DeleteNewsModel>> deleteNews(int reportId);
}
