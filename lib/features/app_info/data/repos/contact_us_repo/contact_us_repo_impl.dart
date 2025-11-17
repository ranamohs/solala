import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/end_points.dart';
import '../../../../../core/data/models/auth_failure_model.dart';
import '../../../../../core/data/models/auth_success_model.dart';
import '../../../../../core/databases/api/dio_consumer.dart';
import '../../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../../core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'contact_us_repo.dart';


class ContactUsRepoImpl implements ContactUsRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper secureStorageHelper;


  ContactUsRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
    required this.secureStorageHelper,

  });

  @override
  Future<Either<AuthFailureModel, AuthSuccessModel>> contactUs(
      {required String name,required String email,required String message,required String subject,
        required String phoneNumber,
      }) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        AuthFailureModel(
          message: AppStrings.noInternetConnection.tr(),
          errors: {
            ApiKey.errors: [AppStrings.noInternetConnection.tr()],
          },
        ),
      );
    }

    try {
      final response = await dioConsumer.post(
          EndPoints.contactUs,
          data: {
            "name":name,
            'email':email,
            'message':message,
            'subject':subject,
            'phone':phoneNumber,}
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response[ApiKey.status] == true) {
          final registerSuccessModel = AuthSuccessModel.fromJson(response);
          return Right(registerSuccessModel);
        } else {
          return Left(AuthFailureModel.fromJson(response));
        }
      } else {
        return Left(
          AuthFailureModel(
            message: AppStrings.serverConnectionFailed.tr(),
            errors: {
              ApiKey.errors: [AppStrings.serverConnectionFailed.tr()],
            },
          ),
        );
      }
    } catch (e) {
      return Left(
        AuthFailureModel(
          message: AppStrings.unexpectedError.tr(),
          errors: {
            ApiKey.errors: [AppStrings.unexpectedError.tr()],
          },
        ),
      );
    }
  }
}