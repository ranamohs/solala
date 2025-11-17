import 'package:solala/core/databases/cache/secure_storage_helper.dart';
import 'package:solala/core/state_management/user_cubit/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final SecureStorageHelper _secureStorageHelper;

  UserCubit({SecureStorageHelper? secureStorageHelper})
      : _secureStorageHelper = secureStorageHelper ?? SecureStorageHelper(),
        super(const UserState(isGuest: true));



  Future<void> checkGuestStatus() async {
    final token = await _secureStorageHelper.getToken();
    final isGuest = token == null || token.isEmpty;

    if (isGuest != state.isGuest) {
      emit(UserState(isGuest: isGuest));
    }
  }

  void setGuestStatus(bool status) {
    if (status != state.isGuest) {
      emit(UserState(isGuest: status));
    }
  }
}
