
class RequestServiceSuccessModel {
  final bool? status;
  final MessageModel? message;
  final dynamic payload;

  RequestServiceSuccessModel({
    this.status,
    this.message,
    this.payload,
  });

  factory RequestServiceSuccessModel.fromJson(Map<String, dynamic> json) {
    return RequestServiceSuccessModel(
      status: json['status'],
      message: MessageModel.fromJson(json['message']),
      payload: json['payload'],
    );
  }
}

class MessageModel {
  final String? ar;
  final String? en;

  MessageModel({
    this.ar,
    this.en,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      ar: json['ar'],
      en: json['en'],
    );
  }
}