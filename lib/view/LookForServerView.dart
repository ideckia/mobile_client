import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ideckia/Log.dart';
import 'package:ideckia/ServerFinder.dart';
import 'package:ideckia/model/Server.dart';
import 'package:ideckia/view/ServerSelectorView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import 'IdeckiaLayoutView.dart';
import 'LogView.dart';
import 'ServerNotFoundView.dart';

class LookForServerView extends StatefulWidget {
  LookForServerView({Key? key}) : super(key: key);
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
  static const int DEFAULT_PORT = 8888;

  String theIp = '';
  Status status = Status.searching;
  int thePort = DEFAULT_PORT;
  int tapCount = 0;
  bool showLog = false;
  List<Server> foundServers = [];
  final manualIpController = TextEditingController(text: '192.168.');
  final manualPortController =
      TextEditingController(text: DEFAULT_PORT.toString());
  final autoPortController =
      TextEditingController(text: DEFAULT_PORT.toString());

  void connectHost(String ip, int port) {
    Log.info('Connecting to IP: $ip / port: $port');

    manualPortController.text = port.toString();
    autoPortController.text = port.toString();
    setState(() {
      status = (ip == '') ? Status.searching : Status.single_found;
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
      theIp = '';
    });
  }

  void toInsertIPFromLogs() {
    setState(() {
      status = Status.not_found;
      tapCount = 0;
      showLog = false;
      theIp = '';
    });
  }

  @override
  void initState() {
    super.initState();
    status = Status.searching;
    theIp = '';
    thePort = DEFAULT_PORT;
  }

  @override
  Widget build(BuildContext context) {
    var retWidget;

    if (showLog) {
      retWidget = LogView(
        toInsertIP: toInsertIPFromLogs,
        reload: reloadFromLogs,
      );
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
        manualIpController: manualIpController,
        manualPortController: manualPortController,
        autoPortController: autoPortController,
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
          manualIpController: manualIpController,
          manualPortController: manualPortController,
          autoPortController: autoPortController,
          callback: connectHost,
        ),
      );
    }

    return Listener(
      onPointerDown: (_) {
        tapCount++;
        if (tapCount >= 3) {
          setState(() {
            tapCount = 0;
            showLog = !showLog;
          });
        }
      },
      onPointerUp: (_) {
        if (tapCount > 0) {
          tapCount--;
        }
      },
      child: retWidget,
    );
  } // build
}
