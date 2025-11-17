import 'package:dartz/dartz.dart';

import '../../../../../core/data/models/basic_model.dart';
import '../../models/default_page_model.dart';

abstract class DefaultPageRepo {
  Future<Either<BasicModel, DefaultPageModel>> getDefaultPage(String pageName);
}
