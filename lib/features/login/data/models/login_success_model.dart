class LoginSuccessModel {
  final String? token;
  final UserModel? user;

  LoginSuccessModel({
    this.token,
    this.user,
  });

  factory LoginSuccessModel.fromJson(Map<String, dynamic> json) {
    return LoginSuccessModel(
      token: json['token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
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
  final dynamic accountType;
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
      familyId: json['family_id']?.toString(),
      familyName: json['family_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'push_notifications_token': pushNotificationsToken,
      'account_type': accountType,
      'family_id': familyId,
      'family_name': familyName,
    };
  }
}
