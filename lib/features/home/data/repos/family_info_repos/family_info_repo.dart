import 'package:dartz/dartz.dart';
import 'package:solala/core/errors/failure.dart';

import '../../models/family_info_model/family_info_model.dart';

abstract class FamilyInfoRepo {
  Future<Either<Failure, FamilyInfoModel>> getFamilyInfo({
    required String familyId,
  });
}
