import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_chat/classes/server.dart';

class ServerScreen extends StatefulWidget {
  @override
  _ServerScreenState createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  Server server;
  List<String> serverLogs = [];
  TextEditingController controller = TextEditingController();

  initState() {
    super.initState();

    server = Server(
      onData: this.onData,
      onError: this.onError,
    );
  }

  onData(Uint8List data) {
    DateTime time = DateTime.now();
    serverLogs.add(time.hour.toString() +
        "h" +
        time.minute.toString() +
        " : " +
        String.fromCharCodes(data));
    setState(() {});
  }

  onError(dynamic error) {
    print(error);
  }

  dispose() {
    controller.dispose();
    server.stop();
    super.dispose();
  }

  confirmReturn() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("WARNING"),
          content: Text("Leaving this screen will disconnect the server"),
          actions: <Widget>[
            FlatButton(
              child: Text("Exit", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Text(
              "Server",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: server.running ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  server.running ? 'ON' : 'OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        RaisedButton(
          color: server.running ? Colors.red : Colors.green,
          child: server.running
              ? Icon(
                  Icons.stop,
                  color: Colors.white,
                )
              : Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
          onPressed: () async {
            if (server.running) {
              await server.stop();
              this.serverLogs.clear();
            } else {
              await server.start();
            }
            setState(() {});
          },
        ),
      ],
    );
  }

  _messageContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      height: 80,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your message.',
                      ),
                      controller: controller,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          MaterialButton(
            onPressed: () {
              controller.text = "";
            },
            minWidth: 30,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Icon(
              Icons.clear,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          MaterialButton(
            onPressed: () {
              server.broadCast(controller.text);
              controller.text = "";
            },
            minWidth: 30,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }

  _chat() {
    return Expanded(
      flex: 1,
      child: ListView(
        children: serverLogs.map((String log) {
          return Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(log),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: confirmReturn,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  _header(),
                  Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.black12,
                  ),
                  _chat(),
                ],
              ),
            ),
          ),
          _messageContainer(),
        ],
      ),
    );
  }
}
