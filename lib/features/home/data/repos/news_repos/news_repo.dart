import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../models/news_model/news_model.dart';

abstract class ReportsRepo {
  Future<Either<Failure, ReportModel>> getReports();
}
