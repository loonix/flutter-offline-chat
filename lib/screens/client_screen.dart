import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_offline_chat/classes/client.dart';
import 'package:flutter_offline_chat/classes/general.dart';

class ClientScreen extends StatefulWidget {
  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  late Client client;
  List<String> serverLogs = [];
  TextEditingController controller = TextEditingController();
  var ipAddressController = TextEditingController();
  List<Socket> sockets = [];
  String? selectedServerIp;

  initState() {
    super.initState();
    client = Client(
      hostname: "192.168.1.46",
      port: General.defaultServerPort,
      onData: this.onData,
      onError: this.onError,
    );
    ipAddressController = TextEditingController(text: selectedServerIp);
  }

  onData(Uint8List data) {
    serverLogs.add("${DateTime.now()}: ${String.fromCharCodes(data)}");
    setState(() {});
  }

  onError(dynamic error) {
    print(error);
  }

  dispose() {
    controller.dispose();
    client.disconnect();
    super.dispose();
  }

  _connectToServer() {
    return Container(
      color: Colors.blueGrey[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: ipAddressController,
              decoration: InputDecoration(
                hintText: "Enter an ip address",
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white70),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.connect_without_contact,
                    size: 25,
                    color: Colors.green[600],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ElevatedButton(
              onPressed: () async {
                print(ipAddressController);
                client.hostname = ipAddressController.text;
                if (client.connected) {
                  await client.disconnect();
                  this.serverLogs.clear();
                } else {
                  await client.connect();
                }
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(90, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24.0),
                  ),
                ),
              ),
              child: Text("ok"),
            ),
          ),
        ],
      ),
    );
  }

  _sendMessage() {
    client.write(controller.text);
    this.onData(Uint8List.fromList('Client: ${controller.text}'.codeUnits));
    for (Socket socket in sockets) {
      socket.write(controller.text + '\n');
    }
    controller.text = "";
    if (FocusScope.of(context).isFirstFocus) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  _chat() {
    return Expanded(
      flex: 1,
      child: ListView(
        children: serverLogs.map((String log) {
          return Padding(
            padding: EdgeInsets.all(5),
            child: Text(log, style: TextStyle(color: Colors.white)),
          );
        }).toList(),
      ),
    );
  }

  _messageSender() {
    return Container(
      color: Colors.blueGrey[900],
      height: 80,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Message:', style: TextStyle(fontSize: 8, color: Colors.white30)),
                Expanded(flex: 1, child: TextFormField(style: TextStyle(color: Colors.white), controller: controller)),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: MaterialButton(
              onPressed: () => controller.text = "",
              minWidth: 30,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Icon(Icons.clear, color: Colors.grey),
            ),
          ),
          Flexible(
            flex: 1,
            child: MaterialButton(
              onPressed: () => _sendMessage(),
              minWidth: 30,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Icon(Icons.send, color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (_args != null) {
      selectedServerIp = _args['selectedServerIp'] ?? null;
      setState(() {
        ipAddressController.text = selectedServerIp!;
        client.hostname = selectedServerIp;
        try {
          client.connect();
          client.connected = true;
        } catch (e) {
          client.connected = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Client'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.blueGrey[800],
        child: Column(
          children: <Widget>[
            _connectToServer(),
            _chat(),
            if (client.connected) _messageSender(),
          ],
        ),
      ),
    );
  }
}
