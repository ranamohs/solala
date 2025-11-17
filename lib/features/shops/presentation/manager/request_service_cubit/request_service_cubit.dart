import 'package:solala/features/shops/presentation/manager/request_service_cubit/request_service_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repos/request_service/request_service_repo.dart';


class RequestServiceCubit extends Cubit<RequestServiceState> {
  final RequestServiceRepo requestServiceRepo;

  RequestServiceCubit({required this.requestServiceRepo})
      : super(SelectedServiceInitialState());

  Future<void> selectedService({
    required int shopId,
  }) async {
    emit(SelectedServiceLoadingState());
    final result = await requestServiceRepo.selectedService(
      shopId: shopId,
    );

    result.fold(
          (failure) {
        emit(SelectedServiceFailureState(failure));
      },
          (success) {
        emit(SelectedServiceSuccessState());
      },
    );
  }
}