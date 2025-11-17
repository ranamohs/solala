
import '../../../data/models/about_us.dart';


abstract class PrivacyState {}

class PrivacyLoadingState extends PrivacyState {}

class PrivacyCachedLoadingState extends PrivacyState {
  final AboutUsModel cachedData;
  PrivacyCachedLoadingState({required this.cachedData});
}

class PrivacySuccessState extends PrivacyState {
  final AboutUsModel info;
  PrivacySuccessState({required this.info});
}

class PrivacyFailureState extends PrivacyState {
  final String message;
  PrivacyFailureState({required this.message});
}
