import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';

class WebSocketClient {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();
  Timer? _reconnectionTimer;
  final Duration _reconnectInterval = const Duration(seconds: 5);
  late String _url;
  late String _clientId;
  late String _token;

  Stream<dynamic> get messages => _messageController.stream;

  void connect(String url, String clientId, String token) {
    _url = url;
    _clientId = clientId;
    _token = token;
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('$_url?client_id=$_clientId&token=$_token'),
    );
    _channel!.stream.listen(
      (message) => _messageController.add(message),
      onError: (error) {
        _messageController.addError(error);
        _scheduleReconnection();
      },
      onDone: _scheduleReconnection,
    );
  }

  void _scheduleReconnection() {
    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(_reconnectInterval, _connect);
  }

  void disconnect() {
    _reconnectionTimer?.cancel();
    _channel?.sink.close();
    _messageController.close();
  }

  void send(dynamic message) {
    _channel?.sink.add(message);
  }
}
