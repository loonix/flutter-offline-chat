import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

import 'package:flutter_offline_chat/classes/general.dart';
import 'package:flutter_offline_chat/classes/models.dart';

class Server {
  Server({this.onError, this.onData});

  Uint8ListCallback? onData;
  DynamicCallback? onError;
  ServerSocket? server;
  bool running = false;
  List<Socket> sockets = [];

  start() async {
    runZonedGuarded(() async {
      server = await ServerSocket.bind(General.serverIp, General.defaultServerPort);
      this.running = true;
      server!.listen(onRequest);
      this.onData!(Uint8List.fromList('Localhost Server listening on port 4040'.codeUnits));
    }, (Object error, StackTrace stack) async {
      this.onError!(error);
    });
  }

  stop() async {
    await this.server!.close();
    this.server = null;
    this.running = false;
  }

  broadCast(String message) {
    this.onData!(Uint8List.fromList('Server: $message'.codeUnits));
    for (Socket socket in sockets) {
      socket.write(message + '\n');
    }
  }

  onRequest(Socket socket) {
    if (!sockets.contains(socket)) {
      sockets.add(socket);
    }
    socket.listen((Uint8List data) {
      this.onData!(data);
    });
  }
}
