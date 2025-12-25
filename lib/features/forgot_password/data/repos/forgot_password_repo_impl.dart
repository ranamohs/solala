import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/databases/cache/secure_storage_helper.dart';

import '../../../../core/errors/failure.dart';
import 'forgot_password_repo.dart';

class ForgotPasswordRepoImpl implements ForgotPasswordRepo {
  final DioConsumer dioConsumer;
  final SecureStorageHelper secureStorageHelper;

  ForgotPasswordRepoImpl({
    required this.dioConsumer,
    required this.secureStorageHelper,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendVerificationCode({required String email}) async {
    try {
      final response = await dioConsumer.post(
        EndPoints.sendVerificationCode,
        data: {
          'email': email,
        },
      );
      if (response['status'] == false) {
        // Check for the specific validation message first
        if (response['errors'] != null && response['errors']['message'] is String) {
          return Left(ServerFailure(errMessage: response['errors']['message']));
        }
        // Fallback to the general message
        return Left(ServerFailure(errMessage: response['message']['ar'] ?? response['message']['en']));
      }
      return Right(response['message']);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dioConsumer.post(
        EndPoints.resetPassword,
        data: {
          'email': email,
          'code': code,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      return Right(response['message']);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }
}
