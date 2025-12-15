import 'package:solala/core/constants/end_points.dart';

class RegisterDataModel {
  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  final String confirmPassword;
  final int? familyId;
  final String type;

  RegisterDataModel({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.familyId,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKey.name: name,
      ApiKey.phoneNumber: phoneNumber,
      ApiKey.email: email,
      ApiKey.password: password,
      ApiKey.passwordConfirmation: confirmPassword,
      ApiKey.familyId: familyId,
      ApiKey.type: type,
    };
  }

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterDataModel(
      name: json[ApiKey.name],
      phoneNumber: json[ApiKey.phoneNumber],
      email: json[ApiKey.email],
      password: json[ApiKey.password],
      confirmPassword: json[ApiKey.passwordConfirmation],
      familyId: json[ApiKey.familyId],
      type: json[ApiKey.type],
    );
  }
}