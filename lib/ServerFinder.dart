import 'dart:convert';
import 'dart:io';

import 'package:ideckia/Log.dart';

import 'model/Server.dart';

class ServerFinder {
  static List<Server> serverList;
  static int port;

  static Future<List<Server>> discover(int port) async {
    serverList = [];
    ServerFinder.port = port;
    var client = HttpClient();
    client.connectionTimeout = Duration(seconds: 2);
    List<Future<Server>> futures = [];
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

    serverList = [];

    await Future.wait(futures).then((List<Server> serverResponsesList) {
      serverResponsesList.forEach((Server serverResponse) {
        var serverName = serverResponse.name;
        if (serverName == null) {
          return;
        }
        var host = serverResponse.ip;
        Log.info('Response from host: $host / serverName: $serverName');
        serverList.add(Server(serverName, host));
      });
    }).onError((error, stackTrace) {
      Log.error('Error searching for server.', error);
    });

    return (serverList.isEmpty)
        ? Future.value([Server.notFound()])
        : Future.value(serverList);
  }

  static Future<Server> doPing(HttpClient client, String ip) {
    try {
      return client
          .get(ip, port, '/ping')
          .then((HttpClientRequest request) async {
        var response = await request.close();
        var streamContent;
        await for (String t in response.transform(utf8.decoder))
          streamContent = t;
        var serverName =
            (streamContent == null) ? null : jsonDecode(streamContent)['pong'];
        return Future.value(Server(serverName, ip));
      }).catchError((error) {
        return Future.value(Server(null, ip));
      });
    } catch (e) {
      Log.error("Error calling to $ip:$port/ping", e);
      return Future.value(Server(null, ip));
    }
  }
}
