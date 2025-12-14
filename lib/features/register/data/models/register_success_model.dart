import 'package:solala/core/constants/end_points.dart';

class RegisterSuccessModel {
  final bool? status;
  final Message? message;
  final String? token;
  final UserModel? user;

  RegisterSuccessModel({
    this.status,
    this.message,
    this.token,
    this.user,
  });

  factory RegisterSuccessModel.fromJson(Map<String, dynamic> json) {
    return RegisterSuccessModel(
      status: json['status'],
      message:
      json['message'] != null ? Message.fromJson(json['message']) : null,
      token: json['token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}

class Message {
  final String? en;
  final String? ar;

  Message({
    this.en,
    this.ar,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      en: json['en'],
      ar: json['ar'],
    );
  }
}

class UserModel {
  final int? id;
  final String? name;
  final dynamic avatar;
  final String? email;
  final String? phone;
  final dynamic address;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic pushNotificationsToken;
  final String? accountType;
  final String? familyId;
  final String? familyName;

  UserModel({
    this.id,
    this.name,
    this.avatar,
    this.email,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.pushNotificationsToken,
    this.accountType,
    this.familyId,
    this.familyName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      pushNotificationsToken: json['push_notifications_token'],
      accountType: json['account_type'],
      familyId: json['family_id'],
      familyName: json['family_name'],
    );
  }
}
