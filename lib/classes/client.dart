import 'dart:io';
import 'dart:typed_data';

import 'models.dart';

class Client {
  Client({
    this.onError,
    this.onData,
    this.hostname,
    this.port,
  });

  String? hostname;
  int? port;
  Uint8ListCallback? onData;
  DynamicCallback? onError;
  bool connected = false;

  Socket? socket;

  connect({int? port}) async {
    try {
      int connectionPort = port ?? General.defaultServerPort;
      socket = await Socket.connect(hostname, connectionPort);
      socket!.listen(
        onData,
        onError: onError,
        onDone: disconnect,
        cancelOnError: false,
      );
      connected = true;
      onData!(Uint8List.fromList("Connected to ${hostname}:${connectionPort}".codeUnits));
    } on Exception catch (exception) {
      onData!(Uint8List.fromList("Error : $exception".codeUnits));
    }
  }

  write(String message) {
    //Connect standard in to the socket
    socket!.write(message + '\n');
  }

  disconnect() {
    if (socket != null) {
      socket!.destroy();
      connected = false;
    }
  }
}
