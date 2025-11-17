import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/features/search/data/repo/search_repo.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/end_points.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/state_management/network_connection_cubit/network_info.dart';
import '../../../shops/data/models/shops_model.dart';



class ShopsSearchRepoImpl implements ShopsSearchRepo {
  final DioConsumer dioConsumer;
  final NetworkInfo networkInfo;

  ShopsSearchRepoImpl({required this.dioConsumer, required this.networkInfo});

  @override

  Future<Either<Failure, ShopsModel>> searchShops(String query) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final response = await dioConsumer.get(
        EndPoints.searchShops,
        queryParameters: {'q': query},
      );
      final shopsModel = ShopsModel.fromJson(response);
      return Right(shopsModel);
    } catch (e) {
      return Left(ServerFailure(errMessage: AppStrings.serverConnectionFailed.tr()));
    }
  }
}