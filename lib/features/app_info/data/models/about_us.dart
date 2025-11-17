class AboutUsModel {
  final bool? status;
  final Message? message;
  final Data? data;

  AboutUsModel({this.status, this.message, this.data});

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] ?? json['payload'];

    Data? parsedData;
    if (rawData is Map && rawData.isNotEmpty) {
      parsedData = Data.fromJson(Map<String, dynamic>.from(rawData));
    } else if (rawData is List && rawData.isNotEmpty && rawData.first is Map) {
      parsedData = Data.fromJson(Map<String, dynamic>.from(rawData.first as Map));
    } else {

      parsedData = null;
    }

    return AboutUsModel(
      status: _asBool(json['status']),
      message: Message.fromAny(json['message']),
      data: parsedData,
    );
  }


  Map<String, dynamic> toJson() => {
    'status': status,
    if (message != null) 'message': message!.toJson(),
    if (data != null) 'data': data!.toJson(),
  };
}

class Message {
  final String? ar;
  final String? en;

  const Message({this.ar, this.en});


  factory Message.fromAny(dynamic v) {
    if (v == null) return const Message();
    if (v is Map) {
      return Message(
        ar: v['ar']?.toString(),
        en: v['en']?.toString(),
      );
    }
    final s = v.toString();
    return Message(ar: s, en: s);
  }

  Map<String, dynamic> toJson() => {
    'ar': ar,
    'en': en,
  };


  String best(String langCode) =>
      (langCode.toLowerCase().startsWith('ar') ? (ar ?? en) : (en ?? ar)) ?? '';
}

class Data {
  final int? id;
  final Message? name;
  final Message? body;

  Data({this.id, this.name, this.body});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: _toInt(json['id']),
    name: Message.fromAny(json['name']),
    body: Message.fromAny(json['body'] ?? json['content']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (name != null) 'name': name!.toJson(),
    if (body != null) 'body': body!.toJson(),
  };
}

/// --------- Helpers ----------
int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

bool? _asBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase();
    return s == 'true' || s == '1' || s == 'success';
  }
  return null;
}
