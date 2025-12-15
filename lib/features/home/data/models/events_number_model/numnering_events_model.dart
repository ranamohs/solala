class NumberingEventsModel {
  final bool? status;
  final Message? message;
  final Data? data;

  NumberingEventsModel({
    this.status,
    this.message,
    this.data,
  });

  factory NumberingEventsModel.fromJson(Map<String, dynamic> json) {
    return NumberingEventsModel(
      status: json['status'],
      message:
      json['message'] != null ? Message.fromJson(json['message']) : null,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? Data.fromJson(json['data'])
          : null,
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

class Data {
  final int? eventsCount;
  final int? familiesMemberCount;
  final int? newsCount;

  Data({
    this.eventsCount,
    this.familiesMemberCount,
    this.newsCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      eventsCount: json['events_count'],
      familiesMemberCount: json['families_member_count'],
      newsCount: json['news_count'],
    );
  }
}
