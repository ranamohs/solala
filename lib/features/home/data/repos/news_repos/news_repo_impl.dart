import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/databases/api/api_consumer.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/home/data/models/news_model/news_model.dart';
import 'package:solala/features/home/data/repos/news_repos/news_repo.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/end_points.dart';
import '../../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../../core/state_management/network_connection_cubit/network_connection_cubit.dart';


class ReportsRepoImpl implements ReportsRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper? secureStorageHelper;

  ReportsRepoImpl({required this.dioConsumer , required this.networkCubit, required this.secureStorageHelper});
  @override
  Future<Either<Failure, ReportModel>> getReports() async {
    try {
      final isConnected = await networkCubit.networkInfo.isConnected;

      if (!isConnected) {
        return Left(
            NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
      }
      final token = await secureStorageHelper?.getToken();
      final response = await dioConsumer.get(EndPoints.news ,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },);
      return right(ReportModel.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure( errMessage: e.response!.data['message'].toString()));
    }
  }
}
