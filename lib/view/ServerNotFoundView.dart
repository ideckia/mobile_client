import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ServerNotFoundView extends StatelessWidget {
  ServerNotFoundView({
    Key key,
    this.port,
    this.manualIpController,
    this.manualPortController,
    this.autoPortController,
    this.callback,
  }) : super(key: key);
  final int port;
  final manualIpController;
  final manualPortController;
  final autoPortController;
  final Function(String, int) callback;

  Widget createIpColumn(
      title, ipLabel, ipController, portController, buttonLabel) {
    var shadeColor = Colors.yellowAccent.shade100;
    return Expanded(
      flex: 200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text(
                    ipLabel,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
                  (ipController != null)
                      ? Expanded(
                          flex: 20,
                          child: TextField(
                            controller: ipController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              hintText: '192.168.xxx.xxx',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: shadeColor,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          '192.168.1.0-255',
                          style: TextStyle(
                            fontSize: 20,
                            color: shadeColor,
                          ),
                        ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text(
                    tr('insert_port'),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 20,
                    child: TextField(
                      controller: portController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 20,
                        color: shadeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () {
                  callback(
                    (ipController == null) ? null : ipController.text,
                    int.parse(portController.text),
                  );
                },
                child: Center(
                  child: Text(
                    buttonLabel,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('no_server_found_title')),
      ),
      body: Row(
        children: [
          createIpColumn(
            tr('eskuz'),
            tr('insert_ip'),
            manualIpController,
            manualPortController,
            tr('manual_find_server'),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey,
            ),
          ),
          createIpColumn(
            tr('automatikoa'),
            tr('auto_ip'),
            null,
            autoPortController,
            tr('try_auto_find_server'),
          ),
        ],
      ),
    );
  }
}
