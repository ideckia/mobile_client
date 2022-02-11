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

    var showFixedItems = ideckiaLayout.fixedItems.length > 0;

    var itemsPercentage = .85;
    var fixedPercentage = .15;

    var width = screenSize.width;
    var fixedWidth = width * fixedPercentage;
    if (showFixedItems) width *= itemsPercentage;

    var height = screenSize.height;
    int colCount = ideckiaLayout.columns;
    int rowCount = ideckiaLayout.rows;

    var bWidth = width / colCount;
    var bHeight = height / rowCount;

    final buttonSize = min(bWidth, bHeight) * .75;
    final radius = buttonSize / 3;

    final fixedButtonSize = fixedWidth * .75;
    final fixedRadius = fixedButtonSize / 3;

    List<Widget> fixedColumnChildren = [];
    for (var fixedItem in ideckiaLayout.fixedItems) {
      fixedColumnChildren.add(ItemStateView(
        itemState: fixedItem,
        onClick: onItemClick,
        onLongPress: onItemLongPress,
        buttonSize: fixedButtonSize,
        buttonRadius: fixedRadius,
      ));
    }

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

    List<Widget> retChildren = [
      Expanded(
        flex: (1000 * itemsPercentage).round(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rows,
        ),
      ),
    ];

    if (showFixedItems) {
      retChildren.add(
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.yellowAccent.shade100,
          ),
        ),
      );
      retChildren.add(
        Expanded(
          flex: (1000 * fixedPercentage).round(),
          child: Container(
            color: Colors.grey.shade800,
            child: ListView(
              padding: const EdgeInsets.all(5),
              scrollDirection: Axis.vertical,
              children: fixedColumnChildren
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: e,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    }

    return retChildren;
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
            Log.debug(
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
                return Row(
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
