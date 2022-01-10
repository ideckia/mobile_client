import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ServerNotFoundView extends StatelessWidget {
  final manualIpController = TextEditingController();
  final manualPortController = TextEditingController();
  final autoPortController = TextEditingController();
  ServerNotFoundView({
    Key key,
    this.port,
    this.callback,
  }) : super(key: key);
  final int port;
  final Function(String, int) callback;

  @override
  Widget build(BuildContext context) {
    manualPortController.text = port.toString();
    autoPortController.text = port.toString();
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
                    doSelect(
                      manualIpController.text,
                      int.parse(manualPortController.text),
                    );
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
                    doSelect(
                      null,
                      int.parse(autoPortController.text),
                    );
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

  void doSelect(String ip, int port) {
    manualIpController.dispose();
    manualPortController.dispose();
    autoPortController.dispose();

    callback(ip, port);
  }
}
