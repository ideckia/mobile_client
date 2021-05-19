import 'package:flutter/material.dart';
import 'package:ideckia/IpFinder.dart';
import 'package:web_socket_channel/io.dart';

import 'IdeckiaLayoutView.dart';
import 'dart:convert';

import 'package:ideckia/model/IdeckiaLayout.dart';
import 'package:ideckia/model/ServerMsg.dart';

class LookForIpView extends StatefulWidget {
  LookForIpView({Key key}) : super(key: key);
  //
  @override
  _LookForIpViewState createState() => _LookForIpViewState();
}

class _LookForIpViewState extends State<LookForIpView> {
  int foundIp = -2;
  int port = 5050;
  IOWebSocketChannel channel;
  final manualIpController = TextEditingController();
  final portController = TextEditingController();

  void setIp(int theIp) {
    print('setIp: ${theIp.toString()}');
    setState(() => {foundIp = theIp});
  }

  @override
  void initState() {
    super.initState();
    IpFinder.discover('', port, setIp);
    portController.text = port.toString();
  }

  void onItemClick(int itemId) {
    print('call to ws: $itemId');
    channel.sink.add(
        jsonEncode({'type': 'click', 'whoami': 'client', 'itemId': itemId}));
  }

  Widget notFound() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Could not connect to server'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                foundIp = -2;
                IpFinder.discover('', port, setIp);
              },
              child: Center(
                child: Text(
                  'Server not found, retry.',
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Enter IP address',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 100,
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: manualIpController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: portController,
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
                      foundIp = int.parse(manualIpController.text);
                      port = int.parse(portController.text);
                    });
                  },
                  child: Center(
                    child: Text(
                      'Try.',
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('foundIp: $foundIp : $port');
    if (foundIp == -2) {
      return new Center(
        child: new CircularProgressIndicator(
          semanticsValue: "Looking for a ideckia server",
        ),
      );
    } else if (foundIp == -1) {
      return notFound();
    } else {
      var url = 'ws://192.168.1.$foundIp:8080';
      channel = IOWebSocketChannel.connect(url);

      return Scaffold(
        body: StreamBuilder(
            stream: channel.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              print('snapshot: $snapshot');
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  ServerMsg serverMsg =
                      ServerMsg.fromJson(jsonDecode(snapshot.data));
                  if (serverMsg.type == 'layout') {
                    print('new layout');
                    return IdeckiaLayoutView(
                      ideckiaLayout: IdeckiaLayout.fromJson(serverMsg.data),
                      onItemClick: onItemClick,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24.0,
                    ),
                    child: Text(
                      snapshot.hasData ? '${snapshot.data}' : '',
                    ),
                  );
                case ConnectionState.done:
                  return notFound();
                default:
                  return new Center(
                    child: new CircularProgressIndicator(),
                  );
              }
            }),
      );
    }
  } // build

  @override
  void dispose() {
    manualIpController.dispose();
    super.dispose();
  }
}
