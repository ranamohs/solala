import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../models/news_model/news_model.dart';

abstract class NewsRepo {
  Future<Either<Failure, NewsModel>> getReports();
}
