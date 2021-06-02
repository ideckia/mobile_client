import 'package:flutter/material.dart';
import 'package:ideckia/IpFinder.dart';
import 'package:web_socket_channel/io.dart';

import 'IdeckiaLayoutView.dart';

class LookForIpView extends StatefulWidget {
  LookForIpView({Key key}) : super(key: key);
  //
  @override
  _LookForIpViewState createState() => _LookForIpViewState();
}

class _LookForIpViewState extends State<LookForIpView> {
  int foundIp = -2;
  int port = 8888;
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
              style: ElevatedButton.styleFrom(minimumSize: Size(100, 150)),
              child: Center(
                child: Text(
                  'Server not found, retry.',
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Enter IP address:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 100,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    '192.168.1.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: EdgeInsets.zero,
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
                  width: 8,
                  padding: EdgeInsets.zero,
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: EdgeInsets.zero,
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
      var url = 'ws://192.168.1.$foundIp:$port';
      return IdeckiaLayoutView(
        channel: IOWebSocketChannel.connect(url),
        defaultWidget: notFound(),
      );
    }
  } // build

  @override
  void dispose() {
    manualIpController.dispose();
    super.dispose();
  }
}
