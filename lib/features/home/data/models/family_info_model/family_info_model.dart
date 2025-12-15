class FamilyInfoModel {
  final bool? status;
  final Message? message;
  final FamilyInfoData? data;

  FamilyInfoModel({
    this.status,
    this.message,
    this.data,
  });

  factory FamilyInfoModel.fromJson(Map<String, dynamic> json) {
    return FamilyInfoModel(
      status: json['status'],
      message:
      json['message'] != null ? Message.fromJson(json['message']) : null,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? FamilyInfoData.fromJson(json['data'])
          : null,
    );
  }
}

class Message {
  String? ar;
  String? en;

  Message({this.ar, this.en});

  Message.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }
}

class FamilyInfoData {
  final int? id;
  final Message? name;
  final String? code;
  final String? negotiatorId;
  final String? negotiator;
  final String? image;

  FamilyInfoData({
    this.id,
    this.name,
    this.code,
    this.negotiatorId,
    this.negotiator,
    this.image,
  });

  factory FamilyInfoData.fromJson(Map<String, dynamic> json) {
    return FamilyInfoData(
      id: json['id'],
      name: json['name'] != null ? Message.fromJson(json['name']) : null,
      code: json['code'],
      negotiatorId: json['negotiator_id'],
      negotiator: json['negotiator'],
      image: json['image'],
    );
  }
}
