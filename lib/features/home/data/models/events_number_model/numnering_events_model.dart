class NumberingEventsModel {
  final bool? status;
  final String? message;
  final Data? data;

  NumberingEventsModel({
    this.status,
    this.message,
    this.data,
  });

  factory NumberingEventsModel.fromJson(Map<String, dynamic> json) {
    return NumberingEventsModel(
      status: json['status'],
      message: json['message']?['en'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
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
