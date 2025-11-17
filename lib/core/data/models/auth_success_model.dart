
import '../../../../core/data/models/localized_text_model.dart';
import '../../constants/end_points.dart';

class AuthSuccessModel {
  final bool status;
  final LocalizedText message;
  final String? token;
  final UserModel? user;
  final dynamic payload;

  AuthSuccessModel({
    required this.status,
    required this.message,
    this.token,
    this.user,
    this.payload,
  });

  factory AuthSuccessModel.fromJson(Map<String, dynamic> json) {
    return AuthSuccessModel(
      status: (json[ApiKey.status] as bool?) == true,
      message: LocalizedText.fromJson(json[ApiKey.message] ?? const {}),
      token: json.containsKey(ApiKey.token) ? json[ApiKey.token] as String? : null,
      user: (json[ApiKey.user] is Map<String, dynamic>)
          ? UserModel.fromJson(json[ApiKey.user] as Map<String, dynamic>)
          : null,
      payload: json.containsKey('payload') ? json['payload'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.status: status,
      ApiKey.message: message.toJson(),
      if (token != null) ApiKey.token: token,
      if (user != null) ApiKey.user: user!.toJson(),
      if (payload != null) 'payload': payload,
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
      name: (json[ApiKey.name] ?? '') as String,
      avatar: json[ApiKey.avatar] as String?,
      email: (json[ApiKey.email] ?? '') as String,
      phone: (json[ApiKey.phone] ?? '') as String,
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
