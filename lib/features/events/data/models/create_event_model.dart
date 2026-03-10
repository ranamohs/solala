import 'dart:io';

import 'package:dio/dio.dart';

class CreateEventModel {
  final String titleAr;
  final String titleEn;
  final String typeAr;
  final String typeEn;
  final String descriptionAr;
  final String descriptionEn;
  final String addressAr;
  final String addressEn;
  final String eventDate;
  final String? familyId;
  final File image;

  CreateEventModel({
    required this.titleAr,
    required this.titleEn,
    required this.typeAr,
    required this.typeEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.addressAr,
    required this.addressEn,
    required this.eventDate,
    this.familyId,
    required this.image,
  });

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = {
      'title[ar]': titleAr,
      'title[en]': titleEn,
      'type[ar]': typeAr,
      'type[en]': typeEn,
      'description[ar]': descriptionAr,
      'description[en]': descriptionEn,
      'address[ar]': addressAr,
      'address[en]': addressEn,
      'event_date': eventDate,
      'image': await MultipartFile.fromFile(image.path),
    };
    if (familyId != null) {
      data['family_id'] = familyId;
    }
    return data;
  }
}
