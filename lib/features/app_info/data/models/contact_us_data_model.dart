
import '../../../../core/constants/end_points.dart';

class ContactUsDataModel {
  final String subject;
  final String name;
  final String phoneNumber;
  final String email;
  final String message;

  ContactUsDataModel(
      {required this.subject,
      required this.name,
      required this.phoneNumber,
      required this.email,
      required this.message});

  Map<String, dynamic> toJson() {
    return {
      ApiKey.subject: subject,
      ApiKey.name: name,
      ApiKey.phoneNumber: phoneNumber,
      ApiKey.email: email,
      ApiKey.message: message,
    };
  }

  factory ContactUsDataModel.fromJson(Map<String, dynamic> json) {
    return ContactUsDataModel(
      subject: json[ApiKey.subject],
      name: json[ApiKey.name],
      phoneNumber: json[ApiKey.phoneNumber],
      email: json[ApiKey.email],
      message: json[ApiKey.message],
    );
  }
}
