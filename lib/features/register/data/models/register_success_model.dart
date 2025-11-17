import 'package:solala/core/constants/end_points.dart';

class RegisterSuccessModel {
  final String token;

  RegisterSuccessModel({
    required this.token,
  });

  factory RegisterSuccessModel.fromJson(Map<String, dynamic> json) {
    return RegisterSuccessModel(
      token: json[ApiKey.token] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.token: token,
    };
  }
}
