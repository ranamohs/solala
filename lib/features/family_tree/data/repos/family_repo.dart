import 'package:dartz/dartz.dart';
import 'package:solala/core/errors/failure.dart';

import '../../../../core/data/models/basic_model.dart';
import '../models/family_model.dart';

abstract class FamilyTreeRepo {
  Future<Either<Failure, FamilyTreeModel>> getFamilyTree();
  Future<Either<Failure, BasicModel>> addFamilyMember({
    required String name,
    required String gender,
    required String relation,
    required int parentId,
    required String avatar,
  });
}
