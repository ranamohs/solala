

import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;
  Failure({required this.errMessage});
}

class NoInternetFailure extends Failure {
  NoInternetFailure({required super.errMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errMessage});
  factory ServerFailure.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errMessage: 'Connection timeout');
      case DioExceptionType.sendTimeout:
        return ServerFailure(errMessage: 'Send timeout');
      case DioExceptionType.receiveTimeout:
        return ServerFailure(errMessage: 'Receive timeout');
      case DioExceptionType.badResponse:
        return ServerFailure.fromBadResponse(e.response!);
      case DioExceptionType.cancel:
        return ServerFailure(errMessage: 'Request was cancelled');
      case DioExceptionType.connectionError:
        return ServerFailure(errMessage: 'Connection error');
      case DioExceptionType.unknown:
        return ServerFailure(errMessage: 'Unknown error');
      case DioExceptionType.badCertificate:
        return ServerFailure(errMessage: 'Bad certificate');
    }
  }

  factory ServerFailure.fromBadResponse(Response response) {
    if (response.data is Map<String, dynamic>) {
      final message = response.data['message'];
      if (message is Map<String, dynamic>) {
        return ServerFailure(
            errMessage:
            message['ar'] ?? message['en'] ?? 'An unknown error occurred');
      } else if (message is String) {
        return ServerFailure(errMessage: message);
      }
    }
    return ServerFailure(errMessage: 'An unknown error occurred');
  }
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure({required super.errMessage});
}
