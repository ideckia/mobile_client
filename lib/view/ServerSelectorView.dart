import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ideckia/Log.dart';
import 'package:ideckia/model/Server.dart';

class ServerSelectorView extends StatelessWidget {
  ServerSelectorView({
    Key key,
    this.servers,
    this.onSelected,
  }) : super(key: key);
  final List<Server> servers;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('servers'),
        ),
      ),
      body: ListView.builder(
        itemCount: servers.length,
        itemBuilder: (context, index) {
          var server = servers[index];
          return ListTile(
            title: Text(server.name),
            subtitle: Text(server.ip),
            tileColor: Colors.blueGrey,
            onTap: () {
              Log.info('Connecting to ' + server.name);
              onSelected(server.ip);
            },
          );
        },
      ),
    );
  }
}
