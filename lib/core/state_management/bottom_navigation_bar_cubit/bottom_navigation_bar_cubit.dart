import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationBarCubit extends Cubit<int> {
  BottomNavigationBarCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }

  void resetToHome() {
    emit(0);
  }
}