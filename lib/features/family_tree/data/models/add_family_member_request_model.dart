import 'package:dio/dio.dart';

class AddFamilyMemberRequestModel {
  final String name;
  final String gender;
  final String relation;
  final int? parentId;
  final String avatar;

  AddFamilyMemberRequestModel({
    required this.name,
    required this.gender,
    required this.relation,
    this.parentId,
    required this.avatar,
  });

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = {
      'name': name,
      'gender': gender,
      'relation': relation,
    };
    if (parentId != null) {
      data['parent_id'] = parentId;
    }
    if (avatar.isNotEmpty) {
      data['avatar'] = await MultipartFile.fromFile(avatar,
          filename: avatar.split('/').last);
    }
    return data;
  }
}
