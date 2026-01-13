import 'package:dio/dio.dart';

class CreateFamilyRequestModel {
  final String nameAr;
  final String nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String code;
  final String image;

  CreateFamilyRequestModel({
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.code,
    required this.image,
  });

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = {
      'name[ar]': nameAr,
      'name[en]': nameEn,
      'code': code,
    };
    if (descriptionAr != null && descriptionAr!.isNotEmpty) {
      data['description[ar]'] = descriptionAr;
    }
    if (descriptionEn != null && descriptionEn!.isNotEmpty) {
      data['description[en]'] = descriptionEn;
    }
    if (image.isNotEmpty) {
      data['image'] = await MultipartFile.fromFile(image,
          filename: image.split('/').last);
    }
    return data;
  }
}
