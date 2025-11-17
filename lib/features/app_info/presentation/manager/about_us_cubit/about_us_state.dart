

import '../../../data/models/about_us.dart';



abstract class AboutUsState {}

class AboutUsLoadingState extends AboutUsState {}

class AboutUsCachedLoadingState extends AboutUsState {
  final AboutUsModel cachedData;
  AboutUsCachedLoadingState({required this.cachedData});
}

class AboutUsSuccessState extends AboutUsState {
  final AboutUsModel info;
  AboutUsSuccessState({required this.info});
}

class AboutUsFailureState extends AboutUsState {
  final String message;
  AboutUsFailureState({required this.message});
}
