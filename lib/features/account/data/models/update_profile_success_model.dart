
import '../../../../core/constants/end_points.dart';
import '../../../../core/data/models/localized_text_model.dart';

class UpdateProfileSuccessModel {
  final bool status;
  final LocalizedText message;
  final UserModel data;

  UpdateProfileSuccessModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateProfileSuccessModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileSuccessModel(
      status: json[ApiKey.status] as bool,
      message: LocalizedText.fromJson(json[ApiKey.message]),
      data: UserModel.fromJson(json[ApiKey.data]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.status: status,
      ApiKey.message: message.toJson(),
      ApiKey.user: data.toJson(),
    };
  }
}

class UserModel {
  final String name;
  final String? avatar;
  final String email;
  final String phone;
  final String? pushNotificationsToken;

  UserModel({
    required this.name,
    this.avatar,
    required this.email,
    required this.phone,
    this.pushNotificationsToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json[ApiKey.name] as String,
      avatar: json[ApiKey.avatar] as String?,
      email: json[ApiKey.email] as String,
      phone: json[ApiKey.phone] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.name: name,
      ApiKey.avatar: avatar,
      ApiKey.email: email,
      ApiKey.phone: phone,
    };
  }
}
