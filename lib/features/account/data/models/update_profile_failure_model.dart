
import '../../../../core/constants/end_points.dart';
import '../../../../core/data/models/localized_text_model.dart';

class UpdateProfileFailureModel {
  final bool status;
  final LocalizedText message;
  final ErrorDetails? errors;

  UpdateProfileFailureModel({
    required this.status,
    required this.message,
    this.errors,
  });

  factory UpdateProfileFailureModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileFailureModel(
      status: json[ApiKey.status] as bool? ?? false,
      message: LocalizedText.fromJson(json[ApiKey.message] ?? {}),
      errors: json.containsKey(ApiKey.errors) && json[ApiKey.errors] is Map
          ? ErrorDetails.fromJson(json[ApiKey.errors])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.status: status,
      ApiKey.message: message.toJson(),
      if (errors != null) ApiKey.errors: errors!.toJson(),
    };
  }
}



class ErrorDetails {
  final String message;
  final Map<String, List<String>>? fieldErrors;

  ErrorDetails({required this.message, this.fieldErrors});

  factory ErrorDetails.fromJson(Map<String, dynamic> json) {
    final rawErrors = json[ApiKey.errors];
    Map<String, List<String>>? parsedFieldErrors;

    if (rawErrors is Map<String, dynamic>) {
      parsedFieldErrors = rawErrors.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
      );
    }

    return ErrorDetails(
      message: json[ApiKey.message] as String? ?? '',
      fieldErrors: parsedFieldErrors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.message: message,
      if (fieldErrors != null) ApiKey.errors: fieldErrors,
    };
  }
}
