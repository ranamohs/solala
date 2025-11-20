import 'package:bloc/bloc.dart';
import 'package:solala/features/events/data/repos/events_repo.dart';

import '../../../data/models/event_model.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventsRepo eventsRepo;

  EventsCubit({required this.eventsRepo}) : super(EventsInitial());

  Future<void> getEvents() async {
    if (isClosed) return;
    emit(EventsLoading());
    final result = await eventsRepo.getEvents();
    if (isClosed) return;
    result.fold(
          (failure) => emit(EventsFailure(errorMessage: failure.errMessage)),
          (events) => emit(EventsSuccess(events: events)),
    );
  }

  Future<void> getEventDetails(int eventId) async {
    if (state is EventsSuccess) {
      final successState = state as EventsSuccess;

      final loadingEvents = Set<int>.from(successState.loadingEvents)..add(eventId);
      if (isClosed) return;
      emit(successState.copyWith(loadingEvents: loadingEvents));

      final result = await eventsRepo.getEventDetails(eventId);
      if (isClosed) return;
      final updatedLoadingEvents = Set<int>.from(successState.loadingEvents)..remove(eventId);

      result.fold(
            (failure) {
          final errorEvents = Map<int, String>.from(successState.errorEvents)
            ..[eventId] = failure.errMessage;
          emit(successState.copyWith(
              loadingEvents: updatedLoadingEvents, errorEvents: errorEvents));
        },
            (eventDetails) {
          final updatedEventDetails =
          Map<int, EventModel>.from(successState.eventDetails)
            ..[eventId] = eventDetails;
          emit(successState.copyWith(
              loadingEvents: updatedLoadingEvents,
              eventDetails: updatedEventDetails));
        },
      );
    }
  }
}
