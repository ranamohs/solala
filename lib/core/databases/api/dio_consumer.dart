
import 'package:solala/core/databases/api/api_consumer.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../constants/end_points.dart';
import 'api_consumer.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baserUrl;
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ));
  }

  /// default headers if none passed
  Map<String, String> get defaultHeaders => {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  //! POST
  @override
  Future post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool isFormData = false,
      }) async {
    try {
      final res = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(await data.toJson()) : data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers ??
              (isFormData
                  ? ({'accept': 'application/json'}..remove('Content-Type'))
                  : defaultHeaders),
        ),
      );
      return res.data;
    } on DioException catch (e) {
      return e.response?.data ?? {'message': 'Unknown error occurred'};
    }
  }
  //! PuT
  Future put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool isFormData = false,
      }) async {
    try {
      final res = await dio.put(
        path,
        data: isFormData ? FormData.fromMap(await data.toJson()) : data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers ??
              (isFormData
                  ? ({'accept': 'application/json'}..remove('Content-Type'))
                  : defaultHeaders),
        ),
      );
      return res.data;
    } on DioException catch (e) {

      return e.response?.data ?? {'message': 'Unknown error occurred'};
    }
  }
  //! GET
  @override
  Future get(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final res = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers ?? defaultHeaders),
      );
      return res.data;
    } on DioException catch (e) {
      return e.response?.data ?? {'message': 'Unknown error occurred'};
    }
  }

  //! DELETE
  @override
  Future delete(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers ?? defaultHeaders),
      );
      return res.data;
    } on DioException catch (e) {
      return e.response?.data ?? {'message': 'Unknown error occurred'};
    }
  }

  //! PATCH
  @override
  Future patch(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool isFormData = false,
        Options? options,
      }) async {
    try {
      final res = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: options ?? Options(headers: headers ?? defaultHeaders),
      );
      return res.data;
    } on DioException catch (e) {
      return e.response?.data ?? {'message': 'Unknown error occurred'};
    }
  }
}
