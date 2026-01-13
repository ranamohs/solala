import 'package:dartz/dartz.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/family_tree/data/models/family_member_details_model.dart';

import '../../../../core/data/models/basic_model.dart';
import '../models/family_model.dart';

abstract class FamilyTreeRepo {
  Future<Either<Failure, FamilyMemberDetailsModel>> getFamilyMemberDetails(
      {required int memberId});
  Future<Either<Failure, FamilyTreeModel>> getFamilyTree();
  Future<Either<Failure, BasicModel>> addFamilyMember({
    required String name,
    required String gender,
    required String relation,
    int? parentId,
    required String avatar,
    String? birthDate,
    String? birthPlace,
    int? isLive,
    String? phone,
    String? job,
  });
  Future<Either<Failure, FamilyMember>> updateFamilyMember({
    required int memberId,
    required String name,
    required String gender,
    required String relation,
    required String avatar,
    String? birthDate,
    String? birthPlace,
    int? isLive,
    String? phone,
    String? job,
  });

  Future<Either<Failure, BasicModel>> deleteFamilyMember({
    required int memberId,
  });
  Future<Either<Failure, BasicModel>> createFamily({
    required String nameAr,
    required String nameEn,
    String? descriptionAr,
    String? descriptionEn,
    required String code,
    required String image,
  });
  Future<Either<Failure, List<FamilyMember>>> searchFamilyTree(
      {required String query});
}
