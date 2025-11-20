import 'package:solala/features/login/data/models/login_success_model.dart';
import 'package:solala/features/login/data/repos/login_repo.dart';
import 'package:solala/features/login/presentation/manager/login_state.dart';
import 'package:solala/core/data/models/auth_failure_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;

  LoginCubit({required this.loginRepo}) : super(LoginInitialState());

  Future<void> login({required String phoneNumber,required String password}) async {
    emit(LoginLoadingState());

    final Either<AuthFailureModel, LoginSuccessModel> result =
    await loginRepo.login(
        phoneNumber: phoneNumber,
        password: password
    );

    result.fold(
            (failure) => emit(LoginFailureState(
            errMessage: failure.message ?? 'An unknown error occurred')),
            (login) =>
            emit(const LoginSuccessState(message: 'Login Successful')));
  }
}
