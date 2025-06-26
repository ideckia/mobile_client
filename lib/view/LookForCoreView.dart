import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ideckia/CoreFinder.dart';
import 'package:ideckia/Log.dart';
import 'package:ideckia/model/Core.dart';
import 'package:ideckia/view/CoreSelectorView.dart';
import 'package:web_socket_channel/io.dart';

import 'CoreNotFoundView.dart';
import 'IdeckiaLayoutView.dart';
import 'LogView.dart';

class LookForCoreView extends StatefulWidget {
  LookForCoreView({Key? key}) : super(key: key);
  //
  @override
  _LookForCoreViewState createState() => _LookForCoreViewState();
}

enum Status {
  searching,
  not_found,
  multiple_found,
  single_found,
}

class _LookForCoreViewState extends State<LookForCoreView> {
  static const int DEFAULT_PORT = 8888;

  String theIp = '';
  Status status = Status.searching;
  int thePort = DEFAULT_PORT;
  int tapCount = 0;
  bool showLog = false;
  List<Core> foundCores = [];
  final ipController = TextEditingController(text: '192.168.1.*');
  final portController = TextEditingController(text: DEFAULT_PORT.toString());

  void connectHost(String address) {
    Log.info('Connecting to address: [$address]');

    var splitAddress = address.split(':');
    var ip = splitAddress[0];
    var port = int.parse(splitAddress[1]);

    portController.text = port.toString();
    setState(() {
      status = (ip.contains('*')) ? Status.searching : Status.single_found;
      theIp = ip;
      thePort = port;
    });
  }

  void coresFound(List<Core> foundCores) {
    this.foundCores = foundCores;
    if (foundCores.length == 0) {
      setState(() {
        status = Status.not_found;
      });
    } else if (foundCores.length > 1) {
      setState(() {
        status = Status.multiple_found;
      });
    } else {
      var core = foundCores[0];
      if (core.name == Core.NOT_FOUND) {
        setState(() {
          status = Status.not_found;
        });
      } else {
        connectHost('${core.ip}:$thePort');
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
    } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      retWidget = IdeckiaLayoutView(
        channel: IOWebSocketChannel.connect(
            'ws://127.0.0.1:' + DEFAULT_PORT.toString()),
        fallbackWidget: new CoreNotFoundView(
          port: thePort,
          ipController: ipController,
          portController: portController,
          callback: connectHost,
        ),
      );
    } else if (status == Status.searching) {
      CoreFinder.discover(thePort).then(coresFound);
      retWidget = new Center(
        child: new CircularProgressIndicator(
          semanticsValue: tr('looking_for_core'),
        ),
      );
    } else if (status == Status.not_found) {
      retWidget = new CoreNotFoundView(
        port: thePort,
        ipController: ipController,
        portController: portController,
        callback: connectHost,
      );
    } else if (status == Status.multiple_found) {
      retWidget = CoreSelectorView(
        cores: foundCores,
        onSelected: (String ip) => connectHost('$ip:$thePort'),
      );
    } else {
      retWidget = IdeckiaLayoutView(
        channel: IOWebSocketChannel.connect('ws://$theIp:$thePort'),
        fallbackWidget: new CoreNotFoundView(
          port: thePort,
          ipController: ipController,
          portController: portController,
          // autoPortController: autoPortController,
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
