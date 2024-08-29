import 'dart:developer';

import 'package:dummy_project/service/socket_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  SocketService? socketService;
  String? loc;

  void init() {
    // Create an instance of the SocketService
    socketService =
        SocketService(onLocationUpdate: handleLocationUpdate, userId: '1');

    socketService?.getLastLocation();
  }

  // // Send a location update
  // socketService.sendLocation('user123', 12.34, 56.78);

  // Request the last known location

  // Define a callback to handle location updates
  void handleLocationUpdate(Map<String, dynamic> data) {
    loc = data['latitude'].toString();
    log('Received location update: $data');
    notifyListeners();
  }

  @override
  void dispose() {
    socketService?.disconnect();
    super.dispose();
  }
}
