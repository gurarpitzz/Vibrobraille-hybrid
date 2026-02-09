import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketManager {
  final String url;
  WebSocketChannel? _channel;
  final Function(String) onMessageReceived;
  final Function() onConnected;
  final Function() onDisconnected;

  SocketManager({
    required this.url,
    required this.onMessageReceived,
    required this.onConnected,
    required this.onDisconnected,
  });

  void connect(String sessionId) async {
    if (_channel != null) {
      _channel!.sink.close();
    }

    try {
      final uri = Uri.parse(url);
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;

      // Identify this device
      _channel!.sink
          .add(jsonEncode({'type': 'IDENTIFY', 'sessionId': sessionId}));

      onConnected();

      _channel!.stream.listen(
        (message) {
          print("WS Received: $message"); // DEBUG LOG
          try {
            final data = jsonDecode(message);
            if (data['type'] == 'BRAILLE_TEXT') {
              print("WS Payload: ${data['payload']}"); // DEBUG LOG
              onMessageReceived(data['payload']);
            } else {
              print("WS Unknown Type: ${data['type']}");
            }
          } catch (e) {
            print("WS Decode Error: $e");
          }
        },
        onDone: () {
          print("WebSocket Stream Done");
          onDisconnected();
        },
        onError: (e) {
          print("WebSocket Stream Error: $e");
          onDisconnected();
        },
      );
    } catch (e) {
      print("Connection failed: $e");
      onDisconnected();
    }
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
