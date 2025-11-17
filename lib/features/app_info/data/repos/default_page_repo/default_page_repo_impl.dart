import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/end_points.dart';
import '../../../../../core/data/models/basic_model.dart';
import '../../../../../core/databases/api/dio_consumer.dart';
import '../../../../../core/databases/cache/cache_helper.dart';
import '../../../../../core/state_management/network_connection_cubit/network_connection_cubit.dart';
import '../../models/default_page_model.dart';
import 'default_page_repo.dart';
import '../../../../../core/data/models/localized_text_model.dart';



class DefaultPageRepoImpl implements DefaultPageRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;

  DefaultPageRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
  });

  @override
  Future<Either<BasicModel, DefaultPageModel>> getDefaultPage(
      String pageName) async {
    final isConnected = await networkCubit.networkInfo.isConnected;
    final cacheKey = pageName;


    final cached = CacheHelper().getDataString(key: cacheKey);
    if (cached != null) {
      try {
        final json = jsonDecode(cached) as Map<String, dynamic>;
        final model = DefaultPageModel.fromJson(json);
        return Right(model);
      } catch (e) {

      }
    }


    if (!isConnected) {
      return Left(
        BasicModel(
          payload: null,
          status: false,
          message: LocalizedText(
            ar: AppStrings.noInternetConnection.tr(),
            en: AppStrings.noInternetConnection.tr(),
          ),
        ),
      );
    }


    try {
      final response = await dioConsumer.get('${EndPoints.defaultPage}$pageName');

      if (response != null && response is Map<String, dynamic>) {

        if (response[ApiKey.status] == true) {
          final model = DefaultPageModel.fromJson(response);


          await CacheHelper().saveData(
            key: cacheKey,
            value: jsonEncode(model.toJson()),
          );

          return Right(model);
        } else {

          return Left(BasicModel.fromJson(response));
        }
      }


      return Left(
        BasicModel(
          payload: null,
          status: false,
          message: LocalizedText(
            ar: AppStrings.serverConnectionFailed.tr(),
            en: AppStrings.serverConnectionFailed.tr(),
          ),
        ),
      );
    } catch (e, stack) {
      return Left(
        BasicModel(
          payload: null,
          status: false,
          message: LocalizedText(
            ar: AppStrings.serverConnectionFailed.tr(),
            en: AppStrings.serverConnectionFailed.tr(),
          ),
        ),
      );
    }
  }
}

