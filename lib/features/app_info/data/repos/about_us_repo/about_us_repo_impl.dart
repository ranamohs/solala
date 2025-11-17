
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constants/end_points.dart';
import '../../../../../core/databases/api/dio_consumer.dart';
import '../../models/about_us.dart';
import 'about_us_repo.dart';

class AboutUsRepoImpl implements AboutUsRepo {
  final DioConsumer dioConsumer;
  AboutUsRepoImpl({required this.dioConsumer});

  @override
  Future<Either<String, AboutUsModel>> fetchAboutUs() async {
    try {
      final res = await dioConsumer.get(EndPoints.aboutUs);

      Map<String, dynamic>? body;
      int? statusCode;

      if (res is Response) {
        statusCode = res.statusCode;
        final d = res.data;
        if (d is Map<String, dynamic>) body = d;
      } else if (res is Map<String, dynamic>) {
        body = res;
      }

      if (body == null) {
        return const Left('Invalid response format');
      }

      String _normMsg(dynamic m) {
        if (m == null) return '';
        if (m is String) return m.trim();
        if (m is Map) {
          final ar = m['ar']?.toString().trim();
          final en = m['en']?.toString().trim();
          if (ar != null && ar.isNotEmpty) return ar;
          if (en != null && en.isNotEmpty) return en;
          if (m.isNotEmpty) return m.values.first.toString();
        }
        return m.toString();
      }

      final ok = (body['status'] == true) ||
          (body['success'] == true) ||
          (statusCode != null && statusCode >= 200 && statusCode < 300);

      final model = AboutUsModel.fromJson(body);

      if (ok) {
        return Right(model);
      } else {
        final msg = _normMsg(body['message']);
        return Left(msg.isNotEmpty ? msg : 'Failed to load About-us');
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = e.message ?? 'Request failed';
      if (data is Map<String, dynamic>) {
        final m = data['message'];
        if (m != null) {
          if (m is String && m.trim().isNotEmpty) msg = m.trim();
          if (m is Map) {
            msg = m['ar']?.toString() ??
                m['en']?.toString() ??
                (m.values.isNotEmpty ? m.values.first.toString() : msg);
          }
        }
      }
      return Left(msg);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
