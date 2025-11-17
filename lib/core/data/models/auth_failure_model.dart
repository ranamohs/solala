import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/data/models/localized_text_model.dart';

class AuthFailureModel {
  final String? message;
  final LocalizedText? messageLocalized;
  final Map<String, List<String>>? errors;

  AuthFailureModel({
    this.message,
    this.messageLocalized,
    this.errors,
  }) : assert(
  message != null || messageLocalized != null,
  'Either messageString or messageLocalized must be provided',
  );


  factory AuthFailureModel.fromJson(Map<String, dynamic> json) {
    String? extractedMessageString;
    LocalizedText? extractedMessageLocalized;
    Map<String, List<String>>? extractedErrors;

    // Handle validation failure structure
    if (json.containsKey('errors') &&
        json['errors'] is Map &&
        json['errors'].containsKey('message')) {
      var msgData = json['errors']['message'];


      if (msgData is Map && (msgData.containsKey('ar') || msgData.containsKey('en'))) {
        extractedMessageLocalized = LocalizedText.fromJson(msgData as Map<String, dynamic>);
      } else {
        extractedMessageString = msgData.toString();
      }

      if (json['errors'].containsKey('errors') &&
          json['errors']['errors'] is Map) {
        extractedErrors =
            (json['errors']['errors'] as Map<String, dynamic>?)?.map(
                  (key, value) => MapEntry(
                key,
                List<String>.from(value.map((item) => item.toString())),
              ),
            );
      }
    }
    // Handle other error structures
    else if (json.containsKey(ApiKey.message)) {
      var msgData = json[ApiKey.message];


      if (msgData is Map && (msgData.containsKey('ar') || msgData.containsKey('en'))) {
        extractedMessageLocalized = LocalizedText.fromJson(msgData as Map<String, dynamic>);
      } else {
        extractedMessageString = msgData.toString();
      }

      if (json.containsKey(ApiKey.errors) && json[ApiKey.errors] is Map) {
        extractedErrors =
            (json[ApiKey.errors] as Map<String, dynamic>?)?.map(
                  (key, value) => MapEntry(
                key,
                List<String>.from(value.map((item) => item.toString())),
              ),
            );
      }
    }
    // Fallback for unexpected structures
    else {
      extractedMessageString = 'An unexpected error occurred.';
    }

    return AuthFailureModel(
      message: extractedMessageString,
      messageLocalized: extractedMessageLocalized,
      errors: extractedErrors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.message: messageLocalized?.toJson() ?? message,
      ApiKey.errors: errors,
    };
  }
}