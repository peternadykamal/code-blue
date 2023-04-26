import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket _socket;

  Future<void> connect() async {
    final url = await _getUrl();
    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      print('Connected to server');
    });
  }

  Future<String> _getUrl() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.activate();
    print(remoteConfig.getString(dotenv.env['CHATBOT_CONFIG_NAME']!));
    return remoteConfig.getString(dotenv.env['CHATBOT_CONFIG_NAME']!);
  }

  void send(String message) {
    _socket.emit('message', message);
  }

  void listen(void Function(dynamic message) onData,
      {Function(dynamic message)? onError, void Function()? onDone}) {
    _socket.on('message', onData);
    if (onError != null) {
      _socket.onError(onError);
    }
    if (onData != null) {
      _socket.onDisconnect((_) {
        print('Disconnected from server');
        onDone?.call();
      });
    }
  }

  void disconnect() {
    _socket.dispose();
  }
}
