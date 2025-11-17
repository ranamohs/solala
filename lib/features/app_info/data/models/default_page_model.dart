
import '../../../../core/constants/end_points.dart';
import '../../../../core/data/models/localized_text_model.dart';

class DefaultPageModel {
  final bool status;
  final LocalizedText? message;
  final PageData? data;

  DefaultPageModel({
    required this.status,
    this.message,
    this.data,
  });

  factory DefaultPageModel.fromJson(Map<String, dynamic> json) {
    return DefaultPageModel(
      status: json[ApiKey.status] as bool? ?? false,
      message: json[ApiKey.message] != null
          ? LocalizedText.fromJson(json[ApiKey.message] as Map<String, dynamic>)
          : null,
      data: json[ApiKey.data] != null
          ? PageData.fromJson(json[ApiKey.data] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.status: status,
      if (message != null) ApiKey.message: message!.toJson(),
      if (data != null) ApiKey.data: data!.toJson(),
    };
  }
}




class PageData {
  final int id;
  final LocalizedText name;
  final LocalizedText body;

  PageData({required this.id, required this.name, required this.body});

  factory PageData.fromJson(Map<String, dynamic> json) {
    return PageData(
      id: json[ApiKey.id],
      name: LocalizedText.fromJson(json[ApiKey.name]),
      body: LocalizedText.fromJson(json[ApiKey.body]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.name: name.toJson(),
      ApiKey.body: body.toJson(),
    };
  }
}
