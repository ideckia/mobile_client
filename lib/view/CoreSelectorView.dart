import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ideckia/Log.dart';
import 'package:ideckia/model/Core.dart';

class CoreSelectorView extends StatelessWidget {
  CoreSelectorView({
    Key? key,
    required this.cores,
    required this.onSelected,
  }) : super(key: key);
  final List<Core> cores;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('cores'),
        ),
      ),
      body: ListView.builder(
        itemCount: cores.length,
        itemBuilder: (context, index) {
          var core = cores[index];
          return ListTile(
            title: Text(
              core.name,
              style: TextStyle(
                color: Colors.yellowAccent,
              ),
            ),
            subtitle: Text(
              core.ip,
              style: TextStyle(
                color: Colors.yellow.shade600,
              ),
            ),
            onTap: () {
              Log.info('Connecting to [${core.name}]');
              onSelected(core.ip);
            },
          );
        },
      ),
    );
  }
}
