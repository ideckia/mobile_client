import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ideckia/IpFinder.dart';
import 'package:web_socket_channel/io.dart';
import 'package:ideckia/Log.dart';

import 'IdeckiaLayoutView.dart';

class LookForIpView extends StatefulWidget {
  LookForIpView({Key key}) : super(key: key);
  //
  @override
  _LookForIpViewState createState() => _LookForIpViewState();
}

class _LookForIpViewState extends State<LookForIpView> {
  String theIp;
  int thePort;
  int tapCount = 0;
  bool showLog = false;
  final manualIpController = TextEditingController();
  final manualPortController = TextEditingController();
  final autoPortController = TextEditingController();

  void setIp(String foundIp, int port) {
    Log.info('ip: $foundIp / port: $port');
    setState(() {
      theIp = foundIp;
      thePort = port;
    });
  }

  @override
  void initState() {
    super.initState();
    theIp = null;
    thePort = 8888;
    manualPortController.text = thePort.toString();
    autoPortController.text = thePort.toString();
  }

  Widget notFound() {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('no_server_found_title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Text(
                  tr('enter_ip'),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 200,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: TextField(
                    controller: manualIpController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: '192.168.xxx.xxx',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 8,
                  padding: EdgeInsets.zero,
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: manualPortController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      theIp = manualIpController.text;
                      thePort = int.parse(manualPortController.text);
                    });
                  },
                  child: Center(
                    child: Text(
                      tr('manual_find_server'),
                    ),
                  ),
                )
              ],
            ),
            Divider(
              height: 50,
            ),
            Row(
              children: <Widget>[
                Text(
                  tr('auto_ip'),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 200,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    '192.168.1.0-255',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  width: 8,
                  padding: EdgeInsets.zero,
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: autoPortController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      theIp = null;
                      thePort = int.parse(autoPortController.text);
                    });
                  },
                  child: Center(
                    child: Text(
                      tr('try_auto_find_server'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget logView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('log'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            tooltip: tr('reset_connection'),
            onPressed: () {
              Log.info('resetting connection');
              setState(() {
                showLog = false;
                theIp = null;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: true,
        child: Text(
          Log.text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var retWidget;

    if (showLog) {
      retWidget = logView();
    } else if (theIp == null) {
      IpFinder.discover(thePort, setIp);
      retWidget = new Center(
        child: new CircularProgressIndicator(
          semanticsValue: tr('looking_for_server'),
        ),
      );
    } else if (theIp == IpFinder.NOT_FOUND) {
      retWidget = notFound();
    } else {
      retWidget = IdeckiaLayoutView(
        channel: IOWebSocketChannel.connect('ws://$theIp:$thePort'),
        defaultWidget: notFound(),
      );
    }

    return Listener(
      onPointerDown: (_) {
        tapCount++;
        if (tapCount >= 3) {
          setState(() {
            showLog = !showLog;
          });
        }
      },
      onPointerUp: (_) {
        tapCount--;
      },
      child: retWidget,
    );
  } // build

  @override
  void dispose() {
    manualIpController.dispose();
    manualPortController.dispose();
    autoPortController.dispose();
    super.dispose();
  }
}
