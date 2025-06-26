import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../Log.dart';

class CoreNotFoundView extends StatelessWidget {
  CoreNotFoundView({
    Key? key,
    required this.port,
    this.ipController,
    this.portController,
    required this.callback,
  }) : super(key: key);
  final int port;
  final ipController;
  final portController;
  final Function(String) callback;

  void toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.deepOrangeAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    WakelockPlus.disable();
    var shadeColor = Colors.yellowAccent.shade100;
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                child: Text(
                  tr('scan_qr_title'),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 100,
            child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 5,
                    cutOutSize: scanArea)),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey,
            ),
          ),
          Expanded(
            flex: 35,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        tr('manual_connect_title'),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        tr('insert_ip'),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 10,
                        child: TextField(
                          controller: ipController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 18,
                            color: shadeColor,
                          ),
                          decoration: InputDecoration(
                            hintText: '192.168.xxx.xxx',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: shadeColor,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        tr('insert_port'),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 10,
                        child: TextField(
                          controller: portController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 18,
                            color: shadeColor,
                          ),
                          decoration: InputDecoration(
                            hintText: '192.168.xxx.xxx',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: shadeColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 10,
                        child: ElevatedButton(
                          onPressed: () {
                            var portText = portController.text;
                            if (portText == null || portText == '') {
                              Log.error("Port is mandatory", null);
                              toast(tr("mandatory_port"));
                              return;
                            }
                            var ipText = '';
                            if (ipController != null) {
                              ipText = ipController.text;
                              if (ipText == '') {
                                Log.error("IP is mandatory", null);
                                toast(tr("mandatory_ip"));
                                return;
                              }
                            }
                            callback('$ipText:$portText');
                          },
                          child: Center(
                            child: Text(
                              tr('search'),
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      callback(scanData.code!);
    });
  }
}
