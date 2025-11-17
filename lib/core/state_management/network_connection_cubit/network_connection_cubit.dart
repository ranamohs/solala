import 'package:solala/core/state_management/network_connection_cubit/network_connection_state.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_info.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkConnectionCubit extends Cubit<NetworkConnectionState> {
  final NetworkInfo networkInfo;

  NetworkConnectionCubit(this.networkInfo) : super(NetworkConnectionInitialState()) {
    _initializeConnection();
    _monitorConnection();
  }

  Future<void> _initializeConnection() async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        emit(NetworkConnected());
      } else {
        emit(NetworkDisconnected());
      }
    } catch (error) {
      emit(NetworkDisconnected());
    }
  }

  void _monitorConnection() {
    networkInfo.connectionStatus.listen((status) {
      if (status == DataConnectionStatus.connected) {
        emit(NetworkConnected());
      } else {
        emit(NetworkDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    // Any cleanup logic (if needed) can be added here.
    return super.close();
  }
}


