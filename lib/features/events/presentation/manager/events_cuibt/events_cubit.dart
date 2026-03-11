import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solala/features/events/data/models/create_event_model.dart';
import 'package:solala/features/events/data/repos/events_repo.dart';

import '../../../../../core/constants/end_points.dart';
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

  Future<void> createEvent({
    required CreateEventModel createEventModel,
    required BuildContext context,
  }) async {
    emit(CreateEventLoading());
    final response = await eventsRepo.createEvent(
      createEventModel: createEventModel,
    );
    response.fold(
          (failure) => emit(CreateEventFailure(message: failure.errMessage)),
          (data) {
        final message = data[ApiKey.message];
        if (message is String) {
          emit(CreateEventSuccess(message: message));
        } else {
          final locale = context.locale;
          final successMessage = message[locale.languageCode] ?? message['en'];
          emit(CreateEventSuccess(message: successMessage));
        }
      },
    );
  }

  Future<void> updateEvent({
    required int eventId,
    required CreateEventModel updateEventModel,
    required BuildContext context,
  }) async {
    emit(UpdateEventLoading());
    final response = await eventsRepo.updateEvent(
      eventId: eventId,
      updateEventModel: updateEventModel,
    );
    response.fold(
          (failure) => emit(UpdateEventFailure(message: failure.errMessage)),
          (data) {
        final message = data[ApiKey.message];
        if (message is String) {
          emit(UpdateEventSuccess(message: message));
        } else {
          final locale = context.locale;
          final successMessage = message[locale.languageCode] ?? message['en'];
          emit(UpdateEventSuccess(message: successMessage));
        }
      },
    );
  }

  Future<void> deleteEvent(int eventId, BuildContext context) async {
    emit(DeleteEventLoading(eventId: eventId));
    final result = await eventsRepo.deleteEvent(eventId);
    result.fold(
          (failure) =>
          emit(DeleteEventFailure(message: failure.errMessage, eventId: eventId)),
          (deleteEventModel) {
        emit(DeleteEventSuccess(
          message: deleteEventModel.message ?? 'Event Deleted Successfully',
          eventId: eventId,
        ));
        getEvents();
      },
    );
  }
}
