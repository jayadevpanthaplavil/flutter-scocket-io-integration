import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;
  final String
      userId; // User ID that should be set when initializing the service
  final Function(Map<String, dynamic>)? onLocationUpdate; // Nullable callback

  SocketService({
    required this.userId, // Ensure userId is passed during initialization
    this.onLocationUpdate,
  }) {
    _initializeSocket();
  }

  // Initialize the socket connection and set up listeners
  void _initializeSocket() {
    _socket = IO.io('http://192.168.1.46:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket?.on('connect', (_) {
      print('Connected to server');
      // Join the user with their ID when connected
      _socket?.emit('join', userId);
    });

    _socket?.on('disconnect', (_) {
      print('Disconnected from server');
    });

    _socket?.on('location_update', (data) {
      if (data['userId'] == userId) {
        if (onLocationUpdate != null) {
          onLocationUpdate!(data);
        }
      }
    });

    _socket?.on('last_location', (data) {
      if (data['userId'] == userId) {
        if (onLocationUpdate != null) {
          onLocationUpdate!(data);
        }
      }
    });

    _socket?.connect();
  }

  // Method to send location updates to the server
  void sendLocation(double latitude, double longitude) {
    _socket?.emit('update_location', {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  // Method to request the last known location from the server
  void getLastLocation() {
    _socket?.emit('get_last_location', userId);
  }

  // Method to disconnect from the server
  void disconnect() {
    _socket?.disconnect();
  }
}
