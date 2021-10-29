import 'dart:convert';
import 'dart:io';
import 'package:ideckia/Log.dart';

class IpFinder {
  static int counter = 0;
  static const int MAX_CALLS = 256;
  static var found = false;
  static var called = false;
  static const String NOT_FOUND = 'not_found';

  static void discover(int port, Function(String, int) callback) {
    var client = HttpClient();
    counter = 0;
    found = false;
    called = false;
    client.connectionTimeout = Duration(seconds: 2);
    try {
      for (var i = 0; i < 256; i++) {
        if (called) {
          return;
        }
        doCall(
          client,
          '192.168.1.${i.toString()}',
          port,
          callback,
        );
      }
    } finally {
      client.close();
      if (!called) {
        callback(NOT_FOUND, port);
      }
    }
  }

  static void doCall(
      HttpClient client, String ip, int port, Function(String, int) callback) {
    try {
      client
          .getUrl(Uri.parse('http://$ip:${port.toString()}/ping'))
          .then((HttpClientRequest request) {
        return request.close();
      }).catchError((error) {
        counter++;
        Log.error('#${counter.toString()} connecting', error);
        if (counter == MAX_CALLS && !found) {
          callback(NOT_FOUND, port);
          called = true;
        }
        return null;
      }).then((HttpClientResponse response) {
        if (response != null) {
          response.transform(utf8.decoder).listen((contents) {
            if (contents == 'pong') {
              found = true;
              callback(ip, port);
              called = true;
            }
          });
        }
      }).catchError((error) {
        counter++;
        Log.error('#${counter.toString()} getting response', error);
        if (counter == MAX_CALLS && !found) {
          callback(NOT_FOUND, port);
          called = true;
        }
        return null;
      });
    } catch (e) {
      counter++;
      Log.error('#${counter.toString()}', e);
      if (counter == MAX_CALLS && !found) {
        callback(NOT_FOUND, port);
        called = true;
      }
      return null;
    }
  }
}
