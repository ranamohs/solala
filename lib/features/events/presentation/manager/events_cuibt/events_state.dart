import 'package:solala/features/events/data/models/event_model.dart';

abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsSuccess extends EventsState {
  final List<EventModel> events;
  final Map<int, EventModel> eventDetails;
  final Set<int> loadingEvents;
  final Map<int, String> errorEvents;

  EventsSuccess({
    required this.events,
    this.eventDetails = const {},
    this.loadingEvents = const {},
    this.errorEvents = const {},
  });

  EventsSuccess copyWith({
    List<EventModel>? events,
    Map<int, EventModel>? eventDetails,
    Set<int>? loadingEvents,
    Map<int, String>? errorEvents,
  }) {
    return EventsSuccess(
      events: events ?? this.events,
      eventDetails: eventDetails ?? this.eventDetails,
      loadingEvents: loadingEvents ?? this.loadingEvents,
      errorEvents: errorEvents ?? this.errorEvents,
    );
  }
}

class EventsFailure extends EventsState {
  final String errorMessage;

  EventsFailure({required this.errorMessage});
}

class CreateEventLoading extends EventsState {}

class CreateEventSuccess extends EventsState {
  final String message;

  CreateEventSuccess({required this.message});
}

class CreateEventFailure extends EventsState {
  final String message;

  CreateEventFailure({required this.message});
}

class DeleteEventLoading extends EventsState {
  final int eventId;

  DeleteEventLoading({required this.eventId});
}

class DeleteEventSuccess extends EventsState {
  final String message;
  final int eventId;

  DeleteEventSuccess({required this.message, required this.eventId});
}

class DeleteEventFailure extends EventsState {
  final String message;
  final int eventId;

  DeleteEventFailure({required this.message, required this.eventId});
}
