import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ideckia/model/IdeckiaLayout.dart';
import 'package:ideckia/model/ItemState.dart';
import 'package:ideckia/model/ServerMsg.dart';
import 'package:ideckia/view/ItemStateView.dart';
import 'package:web_socket_channel/io.dart';

class IdeckiaLayoutView extends StatelessWidget {
  IdeckiaLayoutView(
      {Key key, this.ideckiaLayout, this.channel, this.defaultWidget})
      : super(key: key);
  final IdeckiaLayout ideckiaLayout;
  final IOWebSocketChannel channel;
  final Widget defaultWidget;

  void onItemClick(int itemId) {
    channel.sink.add(
      jsonEncode({
        'type': 'click',
        'whoami': 'client',
        'itemId': itemId,
      }),
    );
  }

  void onItemLongPress(int itemId) {
    channel.sink.add(
      jsonEncode({
        'type': 'longPress',
        'whoami': 'client',
        'itemId': itemId,
      }),
    );
  }

  List<Widget> createLayout(IdeckiaLayout ideckiaLayout, BuildContext context) {
    if (ideckiaLayout == null) {
      return [];
    }

    var mediaQuery = MediaQuery.of(context);
    var screenSize = mediaQuery.size;
    var width = screenSize.width;
    var height = screenSize.height;
    int colCount = ideckiaLayout.columns;
    int rowCount = ideckiaLayout.rows;

    var bWidth = width / rowCount;
    var bHeight = height / colCount;

    final buttonSize = min(bWidth, bHeight);
    final radius = buttonSize / 3;

    List<Widget> rows = [];
    List<Widget> columns;
    int itemIndex;
    ItemState itemState;
    List<ItemState> items = ideckiaLayout.items;
    for (var i = 0; i < rowCount; i++) {
      columns = [];
      for (var j = 0; j < colCount; j++) {
        itemIndex = i * colCount + j;
        if (itemIndex >= items.length) {
          itemState = ItemState.empty();
        } else {
          itemState = items[itemIndex];
        }
        columns.add(ItemStateView(
          itemState: itemState,
          onClick: onItemClick,
          onLongPress: onItemLongPress,
          buttonSize: buttonSize,
          buttonRadius: radius,
        ));
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: columns,
      ));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: channel.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                ServerMsg serverMsg =
                    ServerMsg.fromJson(jsonDecode(snapshot.data));
                if (serverMsg.type == 'layout') {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: createLayout(
                      IdeckiaLayout.fromJson(serverMsg.data),
                      context,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                  ),
                  child: Text(
                    snapshot.hasData ? '${snapshot.data}' : '',
                  ),
                );
              case ConnectionState.done:
                return defaultWidget;
              default:
                return new Center(
                  child: new CircularProgressIndicator(),
                );
            }
          }),
    );
  }
}
