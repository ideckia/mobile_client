import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ideckia/Log.dart';
import 'package:ideckia/model/Server.dart';

class ServerSelectorView extends StatelessWidget {
  ServerSelectorView({
    Key? key,
    required this.servers,
    required this.onSelected,
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
            title: Text(
              server.name,
              style: TextStyle(
                color: Colors.yellowAccent,
              ),
            ),
            subtitle: Text(
              server.ip,
              style: TextStyle(
                color: Colors.yellow.shade600,
              ),
            ),
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
