
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/constants/end_points.dart';
import '../../../../../core/databases/api/dio_consumer.dart';
import '../../models/about_us.dart';
import 'privacy_repo.dart';

class PrivacyRepoImpl implements PrivacyRepo {
  final DioConsumer dioConsumer;
  PrivacyRepoImpl({required this.dioConsumer});

  @override
  Future<Either<String, AboutUsModel>> fetchPrivacy() async {
    try {
      final res = await dioConsumer.get(EndPoints.privacyPolicy);
      Map<String, dynamic>? body;
      int? statusCode;

      if (res is Response) {
        statusCode = res.statusCode;
        if (res.data is Map<String, dynamic>) body = res.data;
      } else if (res is Map<String, dynamic>) {
        body = res;
      }
      if (body == null) return const Left('Invalid response format');

      String _msg(dynamic m) {
        if (m == null) return '';
        if (m is String) return m.trim();
        if (m is Map) {
          final ar = m['ar']?.toString().trim();
          final en = m['en']?.toString().trim();
          return (ar?.isNotEmpty ?? false)
              ? ar!
              : (en?.isNotEmpty ?? false) ? en! : (m.values.isNotEmpty ? m.values.first.toString() : '');
        }
        return m.toString();
      }

      final ok = (body['status'] == true) ||
          (body['success'] == true) ||
          (statusCode != null && statusCode >= 200 && statusCode < 300);

      final model = AboutUsModel.fromJson(body);
      return ok ? Right(model) : Left(_msg(body['message']).isNotEmpty ? _msg(body['message']) : 'Failed to load terms');
    } on DioException catch (e) {
      var msg = e.message ?? 'Request failed';
      final d = e.response?.data;
      if (d is Map<String, dynamic>) {
        final m = d['message'];
        if (m is String && m.trim().isNotEmpty) msg = m.trim();
        if (m is Map) {
          msg = m['ar']?.toString() ?? m['en']?.toString() ?? (m.values.isNotEmpty ? m.values.first.toString() : msg);
        }
      }
      return Left(msg);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
