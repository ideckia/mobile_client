import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../Log.dart';

class LogView extends StatelessWidget {
  LogView({
    Key key,
    this.reload,
  }) : super(key: key);
  final Function reload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('log'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            tooltip: tr('reset_connection'),
            onPressed: () {
              Log.info('resetting connection');
              reload();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: true,
        child: Text(
          Log.text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
