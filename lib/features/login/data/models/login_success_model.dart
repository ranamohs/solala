import 'package:solala/core/constants/end_points.dart';

class LoginSuccessModel {
  final String token;

  LoginSuccessModel({
    required this.token,
  });

  factory LoginSuccessModel.fromJson(Map<String, dynamic> json) {
    return LoginSuccessModel(
      token: json[ApiKey.token] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.token: token,
    };
  }
}
