import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';

import '../Core/api_config.dart';

class ParkingRealtimeService {
  IOWebSocketChannel? _channel;

  Stream<Map<String, dynamic>> connect() {
    _channel?.sink.close();
    _channel = IOWebSocketChannel.connect(
      Uri.parse(ApiConfig.parkingSocketUrl),
      pingInterval: const Duration(seconds: 60),
    );

    return _channel!.stream.transform(
      StreamTransformer<dynamic, Map<String, dynamic>>.fromHandlers(
        handleData: (message, sink) {
          try {
            final decoded = jsonDecode(message.toString());
            if (decoded is Map<String, dynamic>) {
              sink.add(decoded);
            } else if (decoded is Map) {
              sink.add(Map<String, dynamic>.from(decoded));
            }
          } catch (_) {}
        },
      ),
    );
  }

  Future<void> close() async {
    await _channel?.sink.close();
    _channel = null;
  }
}
