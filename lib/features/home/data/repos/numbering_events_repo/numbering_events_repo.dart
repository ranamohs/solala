import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../models/events_number_model/numnering_events_model.dart';


abstract class NumberingEventsRepo {
  Future<Either<Failure, NumberingEventsModel>> getNumberingEvents();
}
