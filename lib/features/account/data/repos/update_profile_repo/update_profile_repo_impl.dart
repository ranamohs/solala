import 'dart:io';

import 'package:solala/features/account/data/repos/update_profile_repo/update_profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/end_points.dart';
import '../../../../../core/data/models/localized_text_model.dart';
import '../../../../../core/databases/api/dio_consumer.dart';
import '../../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../../core/databases/cache/user_data_manager.dart';
import '../../../../../core/state_management/network_connection_cubit/network_connection_cubit.dart';
import '../../models/update_profile_failure_model.dart';
import '../../models/update_profile_success_model.dart';

class UpdateProfileRepoImpl implements UpdateProfileRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper secureStorageHelper;
  final UserDataManager userDataManager;

  UpdateProfileRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
    required this.secureStorageHelper,
    required this.userDataManager,
  });

  @override
  Future<Either<UpdateProfileFailureModel, UpdateProfileSuccessModel>> updateProfile({required String name,required String phoneNumber,required String email,File? avatar}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        UpdateProfileFailureModel(
          status: false,
          message: LocalizedText(
            ar: AppStrings.noInternetConnection.tr(),
            en: AppStrings.noInternetConnection.tr(),
          ),
        ),
      );
    }
    final token = await secureStorageHelper.getToken();
    try {
      final formData = FormData.fromMap({
        ApiKey.name: name,
        ApiKey.phoneNumber: phoneNumber,
        ApiKey.email: email,
        if (avatar != null)
          ApiKey.image: await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split('/').last,
          ),
      });

      final response = await dioConsumer.post(
        EndPoints.updateProfile,
        headers: {
          'Accept':'application/json',
         Params.authorization: "${Params.bearer} $token",
        },
        isFormData: true,
        data: formData,
      );
      if (response != null && response is Map<String, dynamic>) {

        if (response[ApiKey.status] == true) {
          final updateProfileSuccessModel = UpdateProfileSuccessModel.fromJson(response);
          userDataManager.saveUserName(name: response[ApiKey.data][ApiKey.name]);
          userDataManager.saveUserPhoneNumber(phoneNumber: response[ApiKey.data][ApiKey.phoneNumber]);
          userDataManager.saveUserEmail(email: response[ApiKey.data][ApiKey.email]);
          response[ApiKey.data][ApiKey.avatar] == null ? null  :
          userDataManager.saveUserAvatarUrl(avatar: response[ApiKey.data][ApiKey.avatar]);

          return Right(updateProfileSuccessModel);
        } else {
          return Left(UpdateProfileFailureModel.fromJson(response));
        }
      } else {
        return Left(
          UpdateProfileFailureModel(
            status: false,
            message: LocalizedText(
              ar: AppStrings.serverConnectionFailed.tr(),
              en: AppStrings.serverConnectionFailed.tr(),
            ),
          ),
        );
      }
    } catch (e) {
      return Left(
        UpdateProfileFailureModel(
          status: false,
          message: LocalizedText(
            ar: AppStrings.unexpectedError.tr(),
            en: AppStrings.unexpectedError.tr(),
          ),

        ),
      );
    }
  }
}
