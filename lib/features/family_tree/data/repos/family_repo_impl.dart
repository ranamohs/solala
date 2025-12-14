import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';

import '../../../../core/data/models/basic_model.dart';
import '../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/family_model.dart';
import 'family_repo.dart';


class FamilyTreeRepoImpl implements FamilyTreeRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper? secureStorageHelper;


  FamilyTreeRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
    required this.secureStorageHelper,
  });

  @override
  Future<Either<Failure, FamilyTreeModel>> getFamilyTree() async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final response = await dioConsumer.get(EndPoints.familyTree,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },

      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['status'] == true) {
          final familyTreeModel = FamilyTreeModel.fromJson(response);
          return Right(familyTreeModel);
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
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, BasicModel>> createFamily(
      {required String nameAr,
        required String nameEn,
        required String code,
        required String image}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final formData = FormData.fromMap({
        'name[ar]': nameAr,
        'name[en]': nameEn,
        'code': code,
        if (image.isNotEmpty)
          'image': await MultipartFile.fromFile(image,
              filename: image.split('/').last),
      });

      final response = await dioConsumer.post(
        EndPoints.addFamily,
        data: formData,
        isFormData: true,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['status'] == true) {
          final basicModel = BasicModel.fromJson(response);
          return Right(basicModel);
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
// في FamilyTreeRepoImpl
  @override
  Future<Either<Failure, BasicModel>> addFamilyMember({
    required String name,
    required String gender,
    required String relation,
    int? parentId, // تغيير إلى nullable
    required String avatar,
  }) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();

      // إنشاء FormData مع parentId إذا كان غير null
      final formDataMap = <String, dynamic>{
        'name': name,
        'gender': gender,
        'relation': relation,
      };

      // إضافة parent_id فقط إذا كان له قيمة
      if (parentId != null) {
        formDataMap['parent_id'] = parentId;
      }

      // إضافة الصورة إذا كانت موجودة
      if (avatar.isNotEmpty) {
        formDataMap['avatar'] = await MultipartFile.fromFile(
          avatar,
          filename: avatar.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await dioConsumer.post(
        EndPoints.addFamilyMember,
        data: formData,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['status'] == true) {
          final basicModel = BasicModel.fromJson(response);
          return Right(basicModel);
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
  @override
  Future<Either<Failure, FamilyMember>> updateFamilyMember({
    required int memberId,
    required String name,
    required String gender,
    required String relation,
    required String avatar,
  }) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final formData = FormData.fromMap({
        'name': name,
        'gender': gender,
        'relation': relation,
        if (avatar.isNotEmpty)
          'avatar': await MultipartFile.fromFile(avatar,
              filename: avatar.split('/').last),
      });

      final response = await dioConsumer.post(
        '${EndPoints.updateFamilyMember}$memberId',
        data: formData,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['status'] == true) {
          final familyMember = FamilyMember.fromJson(response['data']);
          return Right(familyMember);
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

  @override
  Future<Either<Failure, BasicModel>> deleteFamilyMember(
      {required int memberId}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final response = await dioConsumer.delete(
        '${EndPoints.deleteFamilyMember}$memberId',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('status') && response['status'] == true) {
          final basicModel = BasicModel.fromJson(response);
          return Right(basicModel);
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
