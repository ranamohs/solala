import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/databases/cache/secure_storage_helper.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:solala/features/register/data/models/family_model.dart';
import 'package:solala/features/register/data/models/register_data_model.dart';
import 'package:solala/core/data/models/auth_failure_model.dart';
import 'package:solala/features/register/data/models/register_success_model.dart';
import 'package:solala/features/register/data/repos/register_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';


class RegisterRepoImpl implements RegisterRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper secureStorageHelper;

  RegisterRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
    required this.secureStorageHelper,
  });

  @override
  Future<Either<AuthFailureModel, RegisterSuccessModel>> register(
      {required RegisterDataModel registerData}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(AuthFailureModel(
          message: AppStrings.noInternetConnection.tr(),
          errors: {
            ApiKey.errors: [
              AppStrings.noInternetConnection.tr(),
            ]
          }));
    }

    try {
      final response = await dioConsumer.post(
        EndPoints.register,
        data: registerData.toJson(),
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
            errors: {
              ApiKey.errors: [
                AppStrings.noInternetConnection.tr(),
              ]
            },
          ),
        );
      }
    } catch (e) {
      return Left(
        AuthFailureModel(
          message: AppStrings.unexpectedError.tr(),
          errors: {
            ApiKey.errors: [
              AppStrings.noInternetConnection.tr(),
            ]
          },
        ),
      );
    }
  }

  @override
  Future<Either<AuthFailureModel, List<FamilyModel>>> getFamilies() async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(AuthFailureModel(
          message: AppStrings.noInternetConnection.tr(),
          errors: {
            ApiKey.errors: [
              AppStrings.noInternetConnection.tr(),
            ]
          }));
    }

    try {
      final response = await dioConsumer.get(
        EndPoints.families,
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final List<dynamic> familyList = response['data'];
          final List<FamilyModel> families =
          familyList.map((json) => FamilyModel.fromJson(json)).toList();
          return Right(families);
        } else {
          return Left(AuthFailureModel.fromJson(response));
        }
      } else {
        return Left(
          AuthFailureModel(
            message: AppStrings.serverConnectionFailed.tr(),
            errors: {
              ApiKey.errors: [
                AppStrings.noInternetConnection.tr(),
              ]
            },
          ),
        );
      }
    } catch (e) {
      return Left(
        AuthFailureModel(
          message: AppStrings.unexpectedError.tr(),
          errors: {
            ApiKey.errors: [
              AppStrings.noInternetConnection.tr(),
            ]
          },
        ),
      );
    }
  }
}
