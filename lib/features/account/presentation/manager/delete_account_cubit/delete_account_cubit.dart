import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repos/delete_account_repo/delete_account_repo.dart';
import 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountRepo deleteAccountRepo;

  DeleteAccountCubit({required this.deleteAccountRepo})
      : super(DeleteAccountInitialState());

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoadingState());
    final result = await deleteAccountRepo.deleteAccount();

    if (result.status) {
      emit(DeleteAccountSuccessState(success: result));
    } else {
      emit(DeleteAccountFailureState(failure: result));
    }
  }
}