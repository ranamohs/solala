import 'package:dio/dio.dart';
import 'package:solala/core/errors/error_model.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!CacheException
class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CoefficientException extends ServerException {
  CoefficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.badCertificate:
      throw BadCertificateException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request

          throw BadResponseException(ErrorModel.fromJson(e.response!.data));

        case 401: //unauthorized
          throw UnauthorizedException(ErrorModel.fromJson(e.response!.data));

        case 403: //forbidden
          throw ForbiddenException(ErrorModel.fromJson(e.response!.data));

        case 404: //not found
          throw NotFoundException(ErrorModel.fromJson(e.response!.data));

        case 409: //coefficient

          throw CoefficientException(ErrorModel.fromJson(e.response!.data));

        case 504: // Server Exception

          throw BadResponseException(
              ErrorModel(status: 504, errorMessage: e.response!.data));
      }

    case DioExceptionType.cancel:
      throw CancelException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.unknown:
      throw UnknownException(ErrorModel.fromJson(e.response!.data));
  }
}
