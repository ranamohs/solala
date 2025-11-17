import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repos/logout_repo/logout_repo.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutRepo logoutRepo;

  LogoutCubit({required this.logoutRepo}) : super(LogoutInitialState());

  Future<void> logout() async {
    emit(LogoutLoadingState());
    final result = await logoutRepo.logout();

    if (result.status) {
      emit(LogoutSuccessState(success: result));
    } else {
      emit(LogoutFailureState(failure: result));
    }
  }
}