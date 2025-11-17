import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:solala/features/home/data/models/banners_models/banners_model.dart';
import 'package:solala/features/home/data/repos/banners_repo/banners_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

class BannersRepoImpl implements BannersRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;

  BannersRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
  });

  @override
  Future<Either<Failure, BannersModel>> getBanners() async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final response = await dioConsumer.get(EndPoints.banners);

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['status'] == true) {
          final bannerModel = BannersModel.fromJson(response);
          return Right(bannerModel);
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
        return Left(ServerFailure(errMessage: AppStrings.serverConnectionFailed.tr()));
      }
    } catch (e) {
      return Left(UnexpectedFailure(errMessage: AppStrings.unexpectedError.tr()));
    }
  }
}
