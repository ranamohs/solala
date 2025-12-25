

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
      // Handle validation errors (status code 422)
      if (response.statusCode == 422) {
        // Prioritize the specific message if available
        if (response.data['errors'] != null && response.data['errors']['message'] is String) {
          return ServerFailure(errMessage: response.data['errors']['message']);
        }
        // Fallback to the previous logic
        if (response.data['errors'] != null && response.data['errors']['errors'] != null) {
          final errors = response.data['errors']['errors'] as Map<String, dynamic>;
          // Take the first error message from the list
          if (errors.isNotEmpty) {
            final firstErrorField = errors.keys.first;
            final firstErrorMessage = (errors[firstErrorField] as List).first;
            return ServerFailure(errMessage: firstErrorMessage);
          }
        }
      }

      // Handle general message errors
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
