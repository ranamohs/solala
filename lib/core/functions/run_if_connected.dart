import 'package:solala/core/functions/internet_connection_status_snack_bar.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> runIfConnected({
  required BuildContext context,
  required VoidCallback onConnected,
}) async {
  final isConnected = context.read<NetworkConnectionCubit>().state is NetworkConnected;

  if (isConnected) {
    onConnected();
  } else {
    internetConnectionStatusSnackBar(context, isConnected: false);
  }
}


Future<void> runAsyncIfConnected({
  required BuildContext context,
  required Future<void> Function() onConnected,
}) async {
  final isConnected = context.read<NetworkConnectionCubit>().state is NetworkConnected;

  if (isConnected) {
    await onConnected();
  } else {
    internetConnectionStatusSnackBar(context, isConnected: false);
  }
}
