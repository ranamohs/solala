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
        if (response.containsKey(ApiKey.token)) {
          final loginSuccessModel = LoginSuccessModel.fromJson(response);
          await _cacheUserData(response);
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

  Future<void> _cacheUserData(Map<String, dynamic> response) async {
    await secureStorageHelper.saveToken(token: response[ApiKey.token]);
    final userData = response[ApiKey.user];
    userDataManager.saveUserId(id: userData[ApiKey.id]);
    userDataManager.saveUserName(name: userData[ApiKey.name]);
    userDataManager.saveUserEmail(email: userData[ApiKey.email]);
    userDataManager.saveUserPhoneNumber(
        phoneNumber: userData[ApiKey.phoneNumber]);
    userDataManager.saveUserAvatarUrl(avatar: userData[ApiKey.avatar] ?? '');
    userDataManager.saveUserStatus(isGuest: false);
  }
}
