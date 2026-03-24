import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:solala/features/family_tree/data/models/add_family_member_request_model.dart';
import 'package:solala/features/family_tree/data/models/create_family_request_model.dart';
import 'package:solala/features/family_tree/data/models/family_member_details_model.dart';
import 'package:solala/features/family_tree/data/models/update_family_member_request_model.dart';

import '../../../../core/data/models/basic_model.dart';
import '../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/family_model.dart';
import 'family_repo.dart';


import '../../../../core/databases/cache/user_data_manager.dart';


class FamilyTreeRepoImpl implements FamilyTreeRepo {
  final DioConsumer dioConsumer;
  final NetworkConnectionCubit networkCubit;
  final SecureStorageHelper? secureStorageHelper;
  final UserDataManager? userDataManager;


  FamilyTreeRepoImpl({
    required this.dioConsumer,
    required this.networkCubit,
    required this.secureStorageHelper,
    this.userDataManager,
  });

  @override
  Future<Either<Failure, FamilyMemberDetailsModel>> getFamilyMemberDetails(
      {required int memberId}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final response = await dioConsumer.get(
        '${EndPoints.familyTree}/$memberId',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['status'] == true) {
          final memberDetailsModel =
          FamilyMemberDetailsModel.fromJson(response['data']);
          return Right(memberDetailsModel);
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
  Future<Either<Failure, FamilyTreeModel>> getFamilyTree({int page = 1}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final response = await dioConsumer.get(
        EndPoints.familyTree,
        queryParameters: {
          'page': page,
          'per_page': 2,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('status') && response['status'] == true) {
          if (response.containsKey('family') && response['family'] is Map<String, dynamic>) {
            final familyData = response['family'];
            final familyId = familyData['id']?.toString();
            final familyName = familyData['name'];
            if (familyId != null) {
              userDataManager?.saveUserFamilyId(familyId: familyId);
            }
            if (familyName != null && familyName is String) {
              userDataManager?.saveUserFamilyName(familyName: familyName);
            }
          }
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
        String? descriptionAr,
        String? descriptionEn,
        required String code,
        required String image}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final requestModel = CreateFamilyRequestModel(
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        code: code,
        image: image,
      );

      final response = await dioConsumer.post(
        EndPoints.addFamily,
        data: await requestModel.toJson(),
        isFormData: true,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('status') && response['status'] == true) {
          if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
            final data = response['data'];
            final familyId = data['id']?.toString();
            final familyName = data['name'];
            if (familyId != null) {
              userDataManager?.saveUserFamilyId(familyId: familyId);
            }
            if (familyName != null && familyName is String) {
              userDataManager?.saveUserFamilyName(familyName: familyName);
            }
          }
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
  Future<Either<Failure, BasicModel>> addFamilyMember({
    required String name,
    required String gender,
    required String relation,
    int? parentId,
    required String avatar,
    String? birthDate,
    String? birthPlace,
    int? isLive,
    String? phone,
    String? job,
    String? description,
  }) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final requestModel = AddFamilyMemberRequestModel(
        name: name,
        gender: gender,
        relation: relation,
        parentId: parentId,
        avatar: avatar,
        birthDate: birthDate,
        birthPlace: birthPlace,
        isLive: isLive,
        phone: phone,
        job: job,
        description: description,
      );

      final response = await dioConsumer.post(
        EndPoints.addFamilyMember,
        data: await requestModel.toJson(),
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
  @override
  Future<Either<Failure, FamilyMember>> updateFamilyMember({
    required int memberId,
    required String name,
    required String gender,
    required String relation,
    required String avatar,
    String? birthDate,
    String? birthPlace,
    int? isLive,
    String? phone,
    String? job,
    String? description,
  }) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final requestModel = UpdateFamilyMemberRequestModel(
        name: name,
        gender: gender,
        relation: relation,
        avatar: avatar,
        birthDate: birthDate,
        birthPlace: birthPlace,
        isLive: isLive,
        phone: phone,
        job: job,
        description: description,
      );

      final response = await dioConsumer.post(
        '${EndPoints.updateFamilyMember}$memberId',
        data: await requestModel.toJson(),
        isFormData: true,
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

  @override
  Future<Either<Failure, List<FamilyMember>>> searchFamilyTree(
      {required String query}) async {
    final isConnected = await networkCubit.networkInfo.isConnected;

    if (!isConnected) {
      return Left(
          NoInternetFailure(errMessage: AppStrings.noInternetConnection.tr()));
    }

    try {
      final token = await secureStorageHelper?.getToken();
      final response = await dioConsumer.get(
        EndPoints.searchFamilyTree,
        queryParameters: {'q': query},
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['status'] == true) {
          final List<FamilyMember> members = (response['data'] as List)
              .map((member) => FamilyMember.fromJson(member))
              .toList();
          return Right(members);
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
