import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_chat/classes/general.dart';
import 'package:flutter_offline_chat/routes.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';

class FindServers extends StatefulWidget {
  final WifiInfoWrapper wirelessInfo;
  FindServers({Key key, this.wirelessInfo}) : super(key: key);

  @override
  _FindServersState createState() => _FindServersState();
}

class _FindServersState extends State<FindServers> {
  List<String> ipAddressesFound = [];
  StreamSubscription<NetworkAddress> streamSubscription;
  bool inProgress;
  @override
  void initState() {
    inProgress = false;
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  _swipeNetwork() {
    String ip = widget.wirelessInfo.ipAddress;
    String subnet = ip.substring(0, ip.lastIndexOf('.'));
    Stream<NetworkAddress> networkStream = NetworkAnalyzer.discover(subnet, General.defaultServerPort);
    streamSubscription = networkStream.listen((NetworkAddress addr) {
      // print('${addr.ip} - No Channel');
      if (addr.exists && !ipAddressesFound.contains(addr.ip)) {
        print('Found device: ${addr.ip}');
        setState(() {
          ipAddressesFound.add(addr.ip);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _swipeNetwork();
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Scanner'),
      ),
      body: Container(
          child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: ipAddressesFound == null ? 0 : ipAddressesFound.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(Icons.connect_without_contact),
                      ),
                    ],
                  ),
                  title: Text("${ipAddressesFound[index]}:${General.defaultServerPort}"),
                  onTap: () async => {
                    streamSubscription.cancel(),
                    Navigator.pushNamed(
                      context,
                      RouteNames.client,
                      arguments: <dynamic, dynamic>{'selectedServerIp': ipAddressesFound[index]},
                    )
                  },
                ),
              );
            },
          )
        ],
      )),
    );
  }
}
