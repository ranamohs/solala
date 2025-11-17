
import 'package:dartz/dartz.dart';

import '../../../../../core/data/models/auth_failure_model.dart';
import '../../../../../core/data/models/auth_success_model.dart';

abstract class ContactUsRepo {
  Future<Either<AuthFailureModel, AuthSuccessModel>> contactUs(
      {required String name,required String email,required String message,required String subject,
        required String phoneNumber,});
}
