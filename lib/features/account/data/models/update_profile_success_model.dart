
import '../../../login/data/models/login_success_model.dart';
import '../../../../core/constants/end_points.dart';
import '../../../../core/data/models/localized_text_model.dart';

class UpdateProfileSuccessModel {
  final bool status;
  final LocalizedText message;
  final UserModel data;

  UpdateProfileSuccessModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateProfileSuccessModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileSuccessModel(
      status: json[ApiKey.status] as bool,
      message: LocalizedText.fromJson(json[ApiKey.message]),
      data: UserModel.fromJson(json[ApiKey.data]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.status: status,
      ApiKey.message: message.toJson(),
      ApiKey.user: data.toJson(),
    };
  }
}
