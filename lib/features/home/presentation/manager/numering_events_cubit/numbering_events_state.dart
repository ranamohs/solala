import '../../../data/models/events_number_model/numnering_events_model.dart';

abstract class NumberingEventsState {}

class NumberingEventsInitial extends NumberingEventsState {}

class NumberingEventsLoading extends NumberingEventsState {}

class NumberingEventsSuccess extends NumberingEventsState {
  final NumberingEventsModel numberingEventsModel;

  NumberingEventsSuccess(this.numberingEventsModel);
}

class NumberingEventsFailure extends NumberingEventsState {
  final String message;

  NumberingEventsFailure(this.message);
}
