
import '../../../data/models/about_us.dart';


abstract class TermsState {}

class TermsLoadingState extends TermsState {}

class TermsCachedLoadingState extends TermsState {
  final AboutUsModel cachedData;
  TermsCachedLoadingState({required this.cachedData});
}

class TermsSuccessState extends TermsState {
  final AboutUsModel info;
  TermsSuccessState({required this.info});
}

class TermsFailureState extends TermsState {
  final String message;
  TermsFailureState({required this.message});
}
