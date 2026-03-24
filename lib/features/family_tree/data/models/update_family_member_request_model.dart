import 'package:dio/dio.dart';

class UpdateFamilyMemberRequestModel {
  final String name;
  final String gender;
  final String relation;
  final String avatar;
  final String? birthDate;
  final String? birthPlace;
  final int? isLive;
  final String? phone;
  final String? job;
  final String? description;

  UpdateFamilyMemberRequestModel({
    required this.name,
    required this.gender,
    required this.relation,
    required this.avatar,
    this.birthDate,
    this.birthPlace,
    this.isLive,
    this.phone,
    this.job,
    this.description,
  });

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = {
      'name': name,
      'gender': gender,
      'relation': relation,
    };
    if (avatar.isNotEmpty) {
      data['avatar'] =
      await MultipartFile.fromFile(avatar, filename: avatar.split('/').last);
    }
    if (birthDate != null) {
      data['birth_date'] = birthDate;
    }
    if (birthPlace != null) {
      data['birth_place'] = birthPlace;
    }
    if (isLive != null) {
      data['is_live'] = isLive;
    }
    if (phone != null) {
      data['phone'] = phone;
    }
    if (job != null) {
      data['job'] = job;
    }
    if (description != null) {
      data['description'] = description;
    }
    return data;
  }
}
