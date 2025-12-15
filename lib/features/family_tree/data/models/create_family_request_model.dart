import 'package:dio/dio.dart';

class CreateFamilyRequestModel {
  final String nameAr;
  final String nameEn;
  final String code;
  final String image;

  CreateFamilyRequestModel({
    required this.nameAr,
    required this.nameEn,
    required this.code,
    required this.image,
  });

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = {
      'name[ar]': nameAr,
      'name[en]': nameEn,
      'code': code,
    };
    if (image.isNotEmpty) {
      data['image'] = await MultipartFile.fromFile(image,
          filename: image.split('/').last);
    }
    return data;
  }
}
