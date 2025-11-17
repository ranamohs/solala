import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/end_points.dart';
import '../../../../../core/databases/api/dio_consumer.dart';
import '../../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/state_management/network_connection_cubit/network_connection_cubit.dart';
import '../../models/request_service_success_model.dart';
import 'request_service_repo.dart';

class SelectedServiceRepoImpl implements RequestServiceRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper? secureStorageHelper;

  SelectedServiceRepoImpl({
    this.secureStorageHelper,
    required this.dioConsumer,
    required this.networkCubit,
  });

  @override
  Future<Either<Failure, RequestServiceSuccessModel>> selectedService({
    required int shopId,
  }) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final response = await dioConsumer.post(
        '/$shopId${EndPoints.requestService}',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        isFormData: true,
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == true) {
          final model = RequestServiceSuccessModel.fromJson(response);
          return Right(model);
        } else {
          return Left(ServerFailure(
            errMessage: response[ApiKey.message][ApiKey.ar] ??
                AppStrings.serverConnectionFailed.tr(),
          ));
        }
      } else {
        return Left(ServerFailure(
          errMessage: AppStrings.serverConnectionFailed.tr(),
        ));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(errMessage: e.response?.data['message']['ar']));
    }
  }
}