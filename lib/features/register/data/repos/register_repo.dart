import 'package:solala/core/data/models/auth_failure_model.dart';
import 'package:solala/features/register/data/models/register_data_model.dart';
import 'package:solala/features/register/data/models/register_success_model.dart';
import 'package:dartz/dartz.dart';

abstract class RegisterRepo {
  Future<Either<AuthFailureModel, RegisterSuccessModel>> register({required RegisterDataModel registerData});
  Future<Either<AuthFailureModel, RegisterSuccessModel>> verifyLoginCode({required String code});
  Future<Either<AuthFailureModel, String>> joinFamily({required String familyCode});
}
