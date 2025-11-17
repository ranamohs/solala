
import 'package:dartz/dartz.dart';

import '../../models/about_us.dart';


abstract class TermsRepo {
  Future<Either<String, AboutUsModel>> fetchTerms();
}
