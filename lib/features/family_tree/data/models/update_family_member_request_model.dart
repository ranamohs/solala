import 'package:dio/dio.dart';

class UpdateFamilyMemberRequestModel {
  final String name;
  final String gender;
  final String relation;
  final String avatar;

  UpdateFamilyMemberRequestModel({
    required this.name,
    required this.gender,
    required this.relation,
    required this.avatar,
  });

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = {
      'name': name,
      'gender': gender,
      'relation': relation,
    };
    if (avatar.isNotEmpty) {
      data['avatar'] = await MultipartFile.fromFile(avatar,
          filename: avatar.split('/').last);
    }
    return data;
  }
}
