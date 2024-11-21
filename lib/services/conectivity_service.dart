import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  late final StreamSubscription<InternetConnectionStatus> _subscription;

  ConnectivityService(BuildContext context) {
    _subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      if (context.mounted) {
        if (status == InternetConnectionStatus.disconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No internet connection!')),
          );
        }
      }
    });
  }

  Future<InternetConnectionStatus> getCurrentStatus() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected
        ? InternetConnectionStatus.connected
        : InternetConnectionStatus.disconnected;
  }

  void dispose() {
    _subscription.cancel();
  }
}
