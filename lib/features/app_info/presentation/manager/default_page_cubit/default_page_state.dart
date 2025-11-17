
import '../../../../../core/data/models/basic_model.dart';
import '../../../data/models/default_page_model.dart';

abstract class DefaultPageState {}

class DefaultPageInitialState extends DefaultPageState {}

class DefaultPageLoadingState extends DefaultPageState {}

class DefaultPageCachedLoadingState extends DefaultPageState {
  final DefaultPageModel cachedData;
  DefaultPageCachedLoadingState(this.cachedData);
}

class DefaultPageSuccessState extends DefaultPageState {
  final DefaultPageModel info;

  DefaultPageSuccessState(this.info);
}

class DefaultPageFailureState extends DefaultPageState {
  final BasicModel failure;

  DefaultPageFailureState(this.failure);
}
