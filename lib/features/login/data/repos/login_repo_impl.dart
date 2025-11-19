import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/end_points.dart';
import '../../../../core/data/models/auth_failure_model.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../core/databases/cache/user_data_manager.dart';
import '../../../../core/state_management/network_connection_cubit/network_connection_cubit.dart';
import '../models/login_success_model.dart';
import 'login_repo.dart';

class LoginRepoImpl implements LoginRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper secureStorageHelper;
  final UserDataManager userDataManager;

  LoginRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
    required this.secureStorageHelper,
    required this.userDataManager,
  });

  @override
  Future<Either<AuthFailureModel, LoginSuccessModel>> login(
      {required String phoneNumber, required String password}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        AuthFailureModel(
          message: AppStrings.noInternetConnection.tr(),
          errors: {
            ApiKey.errors: [
              AppStrings.noInternetConnection.tr(),
            ]
          },
        ),
      );
    }

    try {
      final response = await dioConsumer.post(
        EndPoints.login,
        data: {
          ApiKey.phoneNumber: phoneNumber,
          ApiKey.password: password,
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == true && response.containsKey(ApiKey.token)) {
          final loginSuccessModel = LoginSuccessModel.fromJson(response);
          await _cacheUserData(loginSuccessModel);
          return Right(loginSuccessModel);
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

  Future<void> _cacheUserData(LoginSuccessModel model) async {
    if (model.token != null) {
      await secureStorageHelper.saveToken(token: model.token!);
    }
    final userData = model.user;
    if (userData != null) {
      userDataManager.saveUserId(id: userData.id ?? 0);
      userDataManager.saveUserName(name: userData.name ?? '');
      userDataManager.saveUserEmail(email: userData.email ?? '');
      userDataManager.saveUserPhoneNumber(phoneNumber: userData.phone ?? '');
      userDataManager.saveUserAvatarUrl(avatar: userData.avatar ?? '');
      userDataManager.saveUserFamilyId(familyId: userData.familyId ?? '');
      userDataManager.saveUserStatus(isGuest: false);
    }
  }
}
