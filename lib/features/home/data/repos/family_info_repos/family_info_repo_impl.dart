import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';


import '../../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/family_info_model/family_info_model.dart';
import 'family_info_repo.dart';

class FamilyInfoRepoImpl implements FamilyInfoRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper? secureStorageHelper;

  FamilyInfoRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
    required this.secureStorageHelper,
  });

  @override
  Future<Either<Failure, FamilyInfoModel>> getFamilyInfo({
    required String familyId,
  }) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final response = await dioConsumer.get(
        '${EndPoints.familyInfo}$familyId',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['status'] == true) {
          final familyInfoModel = FamilyInfoModel.fromJson(response);
          return Right(familyInfoModel);
        } else {
          String errorMessage = AppStrings.unexpectedError.tr();
          if (response['message'] is Map) {
            errorMessage = response['message']['ar'] ?? errorMessage;
          }
          return Left(UnexpectedFailure(
            errMessage: errorMessage,
          ));
        }
      } else {
        return Left(
            ServerFailure(errMessage: AppStrings.serverConnectionFailed.tr()));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }
}
