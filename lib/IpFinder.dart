import 'dart:convert';
import 'dart:io';

class IpFinder {
  static void discover(String baseUrl, int port, Function(int) callback) {
    var client = HttpClient();
    try {
      int counter = 0;
      int max = 256;
      var found = false;
      for (var i = 0; i < max && !found; i++) {
        try {
          String url = 'http://192.168.1.${i.toString()}:${port.toString()}/marco';
          
          client.connectionTimeout = Duration(seconds: 5);
          client.getUrl(Uri.parse(url))
            .then((HttpClientRequest request) {
              return request.close();
            })
            .catchError((error) {
                counter++;
                print('error #${counter.toString()} in url $url: ${error.toString()}');
                if (counter == max-1 && !found) {
                  callback(-1);
                }
                return null;
            })
            .then((HttpClientResponse response) {
              if (response != null) {
                response.transform(utf8.decoder).listen((contents) {
                  if (contents == 'polo') {
                    found = true;
                    callback(i);
                  }
                });
              }
            })
            .catchError((error) {
              counter++;
                print('error #${counter.toString()} in url $url: ${error.toString()}');
                if (counter == max-1 && !found) {
                  callback(-1);
                }
                return null;
            });
        } catch (e) {
          counter++;
          print('error #${counter.toString()}: ${e.toString()}');
          if (counter == max-1 && !found) {
            callback(-1);
          }
          return null;
        }
        
      }
    } finally {
      client.close();
    }
  }
}
