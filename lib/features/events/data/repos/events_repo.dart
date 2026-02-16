import 'package:dartz/dartz.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/events/data/models/event_model.dart';

import '../models/create_event_model.dart';

abstract class EventsRepo {
  Future<Either<Failure, List<EventModel>>> getEvents();
  Future<Either<Failure, EventModel>> getEventDetails(int eventId);

  Future<Either<Failure, Map<String, dynamic>>> createEvent(
      {required CreateEventModel createEventModel});
  Future<Either<Failure, DeleteEventModel>> deleteEvent(int eventId);
}
