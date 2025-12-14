import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/end_points.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/dio_consumer.dart';
import '../../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../../core/databases/cache/user_data_manager.dart';
import '../../../../../core/errors/failure.dart';
import '../../models/events_number_model/numnering_events_model.dart';
import 'numbering_events_repo.dart';

class NumberingEventsRepoImpl implements NumberingEventsRepo {
  final DioConsumer dioConsumer;
  final UserDataManager userDataManager;
  final SecureStorageHelper secureStorageHelper;


  NumberingEventsRepoImpl( {required this.dioConsumer, required this.userDataManager, required this.secureStorageHelper});

  @override
  Future<Either<Failure, NumberingEventsModel>> getNumberingEvents() async {
    try {
      final token = await secureStorageHelper.getToken();
      final familyId = userDataManager.getUserFamilyId();
      if (familyId == null) {
        return Left(ServerFailure(errMessage: 'Family ID not found'));
      }
      final response = await dioConsumer.get(
        '${EndPoints.numberingEvents}$familyId/numbering-events',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return Right(NumberingEventsModel.fromJson(response));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(errMessage: AppStrings.unexpectedError.tr()));
    }
  }
}
