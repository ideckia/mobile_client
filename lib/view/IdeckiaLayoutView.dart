import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ideckia/Log.dart';
import 'package:ideckia/model/IdeckiaLayout.dart';
import 'package:ideckia/model/ItemState.dart';
import 'package:ideckia/model/ServerMsg.dart';
import 'package:ideckia/view/ItemStateView.dart';
import 'package:web_socket_channel/io.dart';

class IdeckiaLayoutView extends StatelessWidget {
  IdeckiaLayoutView({
    Key key,
    this.ideckiaLayout,
    this.channel,
    this.defaultWidget,
  }) : super(key: key);
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

    var bWidth = width / colCount;
    var bHeight = height / rowCount;

    final buttonSize = min(bWidth, bHeight) * .75;
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

  Widget noDataWidget(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
      ),
      child: Text(
        text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: channel.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Log.info(
                "Connection state: ${snapshot.connectionState} / hasData: ${snapshot.hasData} / hasError: ${snapshot.hasError}");
            if (snapshot.hasError) {
              return noDataWidget(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return defaultWidget;
            }

            if (snapshot.hasData) {
              ServerMsg serverMsg =
                  ServerMsg.fromJson(jsonDecode(snapshot.data));
              if (serverMsg != null && serverMsg.type == 'layout') {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: createLayout(
                    IdeckiaLayout.fromJson(serverMsg.data),
                    context,
                  ),
                );
              }
            }

            return noDataWidget(tr('no_data_received'));
          }),
    );
  }
}
