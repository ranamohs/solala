import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repos/numbering_events_repo/numbering_events_repo.dart';
import 'numbering_events_state.dart';

class NumberingEventsCubit extends Cubit<NumberingEventsState> {
  final NumberingEventsRepo _numberingEventsRepo;

  NumberingEventsCubit(this._numberingEventsRepo) : super(NumberingEventsInitial());

  Future<void> getNumberingEvents() async {
    emit(NumberingEventsLoading());
    final result = await _numberingEventsRepo.getNumberingEvents();
    result.fold(
          (failure) => emit(NumberingEventsFailure(failure.errMessage)),
          (numberingEventsModel) => emit(NumberingEventsSuccess(numberingEventsModel)),
    );
  }
}
