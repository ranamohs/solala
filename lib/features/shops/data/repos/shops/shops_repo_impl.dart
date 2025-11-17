import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/features/shops/data/repos/shops/shops_repo.dart';

import '../../../../../core/databases/cache/secure_storage_helper.dart';
import '../../models/shops_model.dart';

class ServicesRepoImpl implements ShopsRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper? secureStorageHelper;


  ServicesRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
    required this.secureStorageHelper,
  });

  @override
  Future<Either<Failure, ShopsModel>> getShops({int? page,required int categoryId}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final queryParameters = {if (page != null) Params.page: page};
      final response = await dioConsumer.get('/$categoryId${EndPoints.shops}',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        queryParameters: queryParameters,
      );
      print(response.toString());
      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey(ApiKey.data) &&
            response.containsKey(ApiKey.meta) &&
            response.containsKey(ApiKey.links)) {
          final servicesModel = ShopsModel.fromJson(response);
          return Right(servicesModel);
        } else {
          return Left(UnexpectedFailure(
            errMessage: AppStrings.unexpectedError.tr(),
          ));
        }
      } else {
        return Left(ServerFailure(
          errMessage: AppStrings.serverConnectionFailed.tr(),
        ));
      }
    } catch (e) {
      return Left(ServerFailure(errMessage: AppStrings.serverConnectionFailed.tr()));
    }
  }
}
