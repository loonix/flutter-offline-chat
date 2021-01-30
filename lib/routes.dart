import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline_chat/main.dart';
import 'package:flutter_offline_chat/screens/client_screen.dart';
import 'package:flutter_offline_chat/screens/find_servers.dart';
import 'package:flutter_offline_chat/screens/server_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class RouteNames {
  RouteNames._();
  static const String main = '/main';
  static const String client = '/client';
  static const String server = '/server';
  static const String findServer = '/find-server';
}

final routes = <String, WidgetBuilder>{
  RouteNames.main: (_) => MainScreen(),
  RouteNames.client: (_) => ClientScreen(),
  RouteNames.server: (_) => ServerScreen(),
  RouteNames.findServer: (_) => FindServers(),
};
