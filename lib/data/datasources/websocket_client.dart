import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  WebSocketChannel? _channel;

  Future<void> connect(String url) async {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void listen(Function(dynamic) onData) {
    _channel?.stream.listen(onData);
  }

  void send(dynamic data) {
    _channel?.sink.add(data);
  }

  void close() {
    _channel?.sink.close();
  }
}
