import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ideckia/Log.dart';
import 'package:ideckia/ServerFinder.dart';
import 'package:ideckia/model/Server.dart';
import 'package:ideckia/view/ServerSelectorView.dart';
import 'package:web_socket_channel/io.dart';

import 'IdeckiaLayoutView.dart';
import 'LogView.dart';
import 'ServerNotFoundView.dart';

class LookForServerView extends StatefulWidget {
  LookForServerView({Key key}) : super(key: key);
  //
  @override
  _LookForServerViewState createState() => _LookForServerViewState();
}

enum Status {
  searching,
  not_found,
  multiple_found,
  single_found,
}

class _LookForServerViewState extends State<LookForServerView> {
  String theIp;
  Status status = Status.searching;
  int thePort;
  int tapCount = 0;
  bool showLog = false;
  List<Server> foundServers;

  void connectHost(String ip, int port) {
    Log.info('ip: $ip / port: $port');
    setState(() {
      status = Status.single_found;
      theIp = ip;
      thePort = port;
    });
  }

  void serversFound(List<Server> foundServers) {
    this.foundServers = foundServers;
    if (foundServers.length > 1) {
      setState(() {
        status = Status.multiple_found;
      });
    } else {
      var server = foundServers[0];
      if (server.name != Server.NOT_FOUND) {
        connectHost(server.ip, thePort);
      } else {
        setState(() {
          status = Status.not_found;
        });
      }
    }
  }

  void reloadFromLogs() {
    setState(() {
      status = Status.searching;
      tapCount = 0;
      showLog = false;
      theIp = null;
    });
  }

  @override
  void initState() {
    super.initState();
    status = Status.searching;
    theIp = null;
    thePort = 8888;
  }

  @override
  Widget build(BuildContext context) {
    var retWidget;

    if (showLog) {
      retWidget = LogView(reload: reloadFromLogs);
    } else if (status == Status.searching) {
      ServerFinder.discover(thePort).then(serversFound);
      retWidget = new Center(
        child: new CircularProgressIndicator(
          semanticsValue: tr('looking_for_server'),
        ),
      );
    } else if (status == Status.not_found) {
      retWidget = new ServerNotFoundView(
        port: thePort,
        callback: connectHost,
      );
    } else if (status == Status.multiple_found) {
      retWidget = ServerSelectorView(
        servers: foundServers,
        onSelected: (String ip) => connectHost(ip, thePort),
      );
    } else {
      retWidget = IdeckiaLayoutView(
        channel: IOWebSocketChannel.connect('ws://$theIp:$thePort'),
        defaultWidget: new ServerNotFoundView(
          port: thePort,
          callback: connectHost,
        ),
      );
    }

    return Listener(
      onPointerDown: (_) {
        tapCount++;
        Log.info('tapDown: $tapCount');
        if (tapCount == 3) {
          setState(() {
            showLog = !showLog;
          });
        }
      },
      onPointerUp: (_) {
        Log.info('tapUp: $tapCount');
        if (tapCount > 0) {
          tapCount--;
        }
      },
      child: retWidget,
    );
  } // build
}
