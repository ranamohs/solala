
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/end_points.dart';
import '../../../../../core/data/models/basic_model.dart';
import '../../../../../core/data/models/localized_text_model.dart';
import '../../../../../core/databases/api/dio_consumer.dart';
import '../../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../../core/databases/cache/user_data_manager.dart';
import '../../../../../core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'logout_repo.dart';

class LogoutRepoImpl implements LogoutRepo {
  final DioConsumer dioConsumer;
  final SecureStorageHelper secureStorageHelper;
  final NetworkConnectionCubit networkCubit;
  final UserDataManager userDataManager;

  LogoutRepoImpl(
      {required this.dioConsumer,
      required this.secureStorageHelper,
      required this.networkCubit,
      required this.userDataManager});

  @override
  Future<BasicModel> logout() async {
    final isConnected = await networkCubit.networkInfo.isConnected;
    if (!isConnected) {
      return BasicModel(
        payload: null,
        status: false,
        message: LocalizedText(
          ar: AppStrings.noInternetConnection.tr(),
          en: AppStrings.noInternetConnection.tr(),
        ),
      );
    }

    final token = await secureStorageHelper.getToken();


    try {
      final response = await dioConsumer.post(
        EndPoints.logout,
        headers: {
          Params.authorization: "${Params.bearer} $token",
        },
      );

      if (response is Map<String, dynamic>) {
        final model = BasicModel.fromJson(response);
        if (model.status == true) {
          await secureStorageHelper.deleteToken();
          userDataManager.clearAllUserData();
          return model;
        } else {
          return model;
        }
      } else {
        return BasicModel(
          payload: null,
          status: false,
          message: LocalizedText(
            ar: AppStrings.serverConnectionFailed.tr(),
            en: AppStrings.serverConnectionFailed.tr(),
          ),
        );
      }
    } catch (e) {
      return BasicModel(
        payload: null,
        status: false,
        message: LocalizedText(
          ar: AppStrings.unexpectedError.tr(),
          en: AppStrings.unexpectedError.tr(),
        ),
      );
    }
  }
}
