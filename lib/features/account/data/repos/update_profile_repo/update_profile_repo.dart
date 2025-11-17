import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../models/update_profile_failure_model.dart';
import '../../models/update_profile_success_model.dart';

abstract class UpdateProfileRepo {
  Future<Either<UpdateProfileFailureModel, UpdateProfileSuccessModel>> updateProfile({required String name,required String phoneNumber,required String email,File? avatar});
}
