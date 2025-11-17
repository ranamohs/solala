import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:solala/features/home/data/models/categories_models/categories_model.dart';
import 'package:solala/features/home/data/repos/categories_repo/categories_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoriesRepoImpl implements CategoriesRepo{
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;

  CategoriesRepoImpl({required this.dioConsumer, required this.networkCubit});
  @override
  Future<Either<Failure, CategoriesModel>> getCategories({int? page}) async{
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final queryParameters = { if (page != null) Params.page: page};
      final response = await dioConsumer.get(EndPoints.categories,
          queryParameters: queryParameters
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey(ApiKey.data) &&
            response.containsKey(ApiKey.meta) &&
            response.containsKey(ApiKey.links)) {
          final categoriesModel = CategoriesModel.fromJson(response);
          return Right(categoriesModel);
        } else {
          return Left(UnexpectedFailure(
            errMessage: AppStrings.unexpectedError.tr(),
          ));
        }
      } else {
        return Left(ServerFailure(errMessage: AppStrings.serverConnectionFailed.tr()));
      }
    } catch (e) {
      return Left(ServerFailure(errMessage: AppStrings.serverConnectionFailed.tr()));
    }
  }
}