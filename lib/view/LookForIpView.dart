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
  int port = 8888;
  final manualIpController = TextEditingController();
  final portController = TextEditingController();

  void setIp(String foundIp) {
    Log.info('setIp: $foundIp');
    setState(() => {
          theIp = foundIp,
        });
  }

  @override
  void initState() {
    super.initState();
    IpFinder.discover(port, setIp);
    portController.text = port.toString();
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
                      theIp = manualIpController.text;
                      port = int.parse(portController.text);
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  theIp = '';
                });
              },
              style: ElevatedButton.styleFrom(minimumSize: Size(100, 150)),
              child: Center(
                child: Text(
                  tr('retry_auto_find_server'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Log.info('ip: $theIp / port: $port');
    if (theIp == null) {
      return new Center(
        child: new CircularProgressIndicator(
          semanticsValue: tr('zerbitzari_bila'),
        ),
      );
    } else if (theIp == IpFinder.NOT_FOUND) {
      return notFound();
    } else {
      return IdeckiaLayoutView(
        channel: IOWebSocketChannel.connect('ws://$theIp:$port'),
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
