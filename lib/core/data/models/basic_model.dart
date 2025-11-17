
import 'package:solala/core/data/models/localized_text_model.dart';

import '../../constants/end_points.dart';

class BasicModel {
  final bool status;
  final LocalizedText message;
  final dynamic payload;

  BasicModel({
    required this.status,
    required this.message,
    this.payload,
  });

  factory BasicModel.fromJson(Map<String, dynamic> json) {
    return BasicModel(
      status: json[ApiKey.status] ?? false,
      message: LocalizedText.fromJson(json[ApiKey.message] ?? {}),
      payload: json[ApiKey.payload],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.status: status,
      ApiKey.message: message.toJson(),
      ApiKey.payload: payload,
    };
  }
}
