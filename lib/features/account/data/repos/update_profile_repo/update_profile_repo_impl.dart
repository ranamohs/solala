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
        ApiKey.phone: phoneNumber, // Corrected key
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
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        isFormData: true,
        data: formData,
      );
      if (response != null && response is Map<String, dynamic>) {
        if (response[ApiKey.status] == true) {
          return _handleSuccessResponse(response);
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
      if (e is DioException &&
          e.response?.data != null &&
          e.response?.data is Map<String, dynamic>) {
        final responseData = e.response!.data;
        if (responseData[ApiKey.status] == true) {
          return _handleSuccessResponse(responseData);
        } else {
          return Left(UpdateProfileFailureModel.fromJson(responseData));
        }
      }
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

  Either<UpdateProfileFailureModel, UpdateProfileSuccessModel>
  _handleSuccessResponse(Map<String, dynamic> response) {
    try {
      final updateProfileSuccessModel =
      UpdateProfileSuccessModel.fromJson(response);
      final userData = updateProfileSuccessModel.data;
      if (userData != null) {
        if (userData.name != null) {
          userDataManager.saveUserName(name: userData.name!);
        }
        if (userData.phone != null) {
          userDataManager.saveUserPhoneNumber(phoneNumber: userData.phone!);
        }
        if (userData.email != null) {
          userDataManager.saveUserEmail(email: userData.email!);
        }
        if (userData.avatar != null && userData.avatar is String) {
          userDataManager.saveUserAvatarUrl(avatar: userData.avatar);
        }
      }
      return Right(updateProfileSuccessModel);
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
