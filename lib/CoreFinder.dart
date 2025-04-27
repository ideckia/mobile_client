import 'dart:convert';
import 'dart:io';

import 'package:ideckia/Log.dart';

import 'model/Core.dart';

class CoreFinder {
  static List<Core> coreList = [];
  static int port = 0;

  static Future<List<Core>> discover(int port) async {
    coreList = [];
    CoreFinder.port = port;
    var client = HttpClient();
    client.connectionTimeout = Duration(seconds: 2);
    List<Future<Core>> futures = [];
    try {
      for (var i = 0; i < 256; i++) {
        futures.add(doPing(
          client,
          '192.168.1.${i.toString()}',
        ));
      }
    } finally {
      client.close();
    }

    coreList = [];

    await Future.wait(futures).then((List<Core> coreResponsesList) {
      coreResponsesList.forEach((Core coreResponse) {
        var coreName = coreResponse.name;
        if (coreName == '') {
          return;
        }
        var host = coreResponse.ip;
        Log.info('Response from host: $host / coreName: $coreName');
        coreList.add(Core(
          name: coreName,
          ip: host,
        ));
      });
    }).onError((error, stackTrace) {
      Log.error('Error searching for core.', error.toString());
    });

    return (coreList.isEmpty)
        ? Future.value([Core.notFound()])
        : Future.value(coreList);
  }

  static Future<Core> doPing(HttpClient client, String ip) {
    try {
      return client
          .get(ip, port, '/ping')
          .then((HttpClientRequest request) async {
        var response = await request.close();
        var streamContent;
        await for (String t in response.transform(utf8.decoder))
          streamContent = t;
        var coreName =
            (streamContent == null) ? null : jsonDecode(streamContent)['pong'];
        return Future.value(Core(
          name: coreName,
          ip: ip,
        ));
      }).catchError((error) {
        Log.error("Error calling to $ip:$port/ping", error.toString());
        return Future.value(Core(
          name: '',
          ip: ip,
        ));
      });
    } catch (e) {
      Log.error("Error calling to $ip:$port/ping", e.toString());
      return Future.value(Core(
        name: '',
        ip: ip,
      ));
    }
  }
}
