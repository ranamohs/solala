import 'package:dio/dio.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/databases/cache/secure_storage_helper.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/features/register/data/models/register_data_model.dart';
import 'package:solala/core/data/models/auth_failure_model.dart';
import 'package:solala/features/register/data/models/register_success_model.dart';
import 'package:solala/features/register/data/repos/register_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterRepoImpl implements RegisterRepo {
  final DioConsumer dioConsumer;
  final SecureStorageHelper secureStorageHelper;
  final UserDataManager userDataManager;

  RegisterRepoImpl({
    required this.dioConsumer,
    required this.secureStorageHelper,
    required this.userDataManager,
  });

  @override
  Future<Either<AuthFailureModel, RegisterSuccessModel>> register(
      {required RegisterDataModel registerData}) async {
    try {
      final response = await dioConsumer.post(
        EndPoints.register,
        data: registerData.toJson(),
        isFormData: true,
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == true) {
          final registerSuccessModel = RegisterSuccessModel.fromJson(response);
          if (registerSuccessModel.token != null &&
              registerSuccessModel.user != null) {
            await secureStorageHelper.saveToken(
                token: registerSuccessModel.token!);
            userDataManager.saveUserName(
                name: registerSuccessModel.user!.name ?? '');
            userDataManager.saveUserEmail(
                email: registerSuccessModel.user!.email ?? '');
            userDataManager.saveUserPhoneNumber(
                phoneNumber: registerSuccessModel.user!.phone ?? '');
            if (registerSuccessModel.user!.id != null) {
              userDataManager.saveUserId(id: registerSuccessModel.user!.id!);
            }
            if (registerSuccessModel.user!.familyId != null) {
              userDataManager.saveUserFamilyId(
                  familyId: registerSuccessModel.user!.familyId!);
            }
            if (registerSuccessModel.user!.familyName != null) {
              userDataManager.saveUserFamilyName(
                  familyName: registerSuccessModel.user!.familyName!);
            }
          }
          return Right(registerSuccessModel);
        } else {
          return Left(AuthFailureModel.fromJson(response));
        }
      } else {
        return Left(
          AuthFailureModel(
            message: AppStrings.serverConnectionFailed.tr(),
          ),
        );
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Left(
        AuthFailureModel(
          message: AppStrings.unexpectedError.tr(),
        ),
      );
    }
  }
  @override
  Future<Either<AuthFailureModel, String>> joinFamily(
      {required String familyCode}) async {
    try {
      final token = await secureStorageHelper.getToken();
      final response = await dioConsumer.post(
        EndPoints.joinFamily,
        data: {'family_code': familyCode},
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },

      );

      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == true) {
          final familyName = response['family'] as String;
          return Right(familyName);
        } else {
          return Left(AuthFailureModel.fromJson(response));
        }
      } else {
        return Left(
          AuthFailureModel(
            message: AppStrings.serverConnectionFailed.tr(),
          ),
        );
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Left(
        AuthFailureModel(
          message: AppStrings.unexpectedError.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<AuthFailureModel, RegisterSuccessModel>> verifyLoginCode(
      {required String code}) async {
    try {
      final response = await dioConsumer.post(
        EndPoints.verifyLoginCode,
        data: {
          'login_code': code,
        },
        isFormData: true,
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey(ApiKey.token)) {
          final registerSuccessModel = RegisterSuccessModel.fromJson(response);
          String token = response[ApiKey.token];
          await secureStorageHelper.saveToken(token: token);
          return Right(registerSuccessModel);
        } else {
          return Left(AuthFailureModel.fromJson(response));
        }
      } else {
        return Left(
          AuthFailureModel(
            message: AppStrings.serverConnectionFailed.tr(),
          ),
        );
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Left(
        AuthFailureModel(
          message: AppStrings.unexpectedError.tr(),
        ),
      );
    }
  }

  Either<AuthFailureModel, T> _handleDioException<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return Left(
          AuthFailureModel(
            message: AppStrings.noInternetConnection.tr(),
          ),
        );
      case DioExceptionType.badResponse:
        if (e.response?.data is Map<String, dynamic>) {
          return Left(AuthFailureModel.fromJson(e.response!.data));
        }
        return Left(
          AuthFailureModel(
            message: AppStrings.serverConnectionFailed.tr(),
          ),
        );
      default:
        return Left(
          AuthFailureModel(
            message: AppStrings.unexpectedError.tr(),
          ),
        );
    }
  }
}
