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
import 'package:wakelock/wakelock.dart';

class IdeckiaLayoutView extends StatelessWidget {
  IdeckiaLayoutView({
    Key? key,
    required this.channel,
    required this.fallbackWidget,
  }) : super(key: key);
  final IOWebSocketChannel channel;
  final Widget fallbackWidget;

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

    var startPosX = .0;
    var startPosY = .0;
    List<Widget> retChildren = [
      Expanded(
        flex: (1000 * itemsPercentage).round(),
        child: Listener(
          onPointerDown: (event) {
            startPosX = event.position.dx;
            startPosY = event.position.dy;
          },
          onPointerUp: (event) {
            var xDragLength = event.position.dx - startPosX;
            var yDragLength = startPosY - event.position.dy;
            var xDragProp = xDragLength / screenSize.width;
            var yDragProp = yDragLength / screenSize.height;
            var threshold = .2;
            if (xDragProp > threshold || yDragProp > threshold) {
              var toDir = (xDragLength > yDragLength) ? 'prev' : 'main';
              channel.sink.add(
                jsonEncode(
                    {'type': 'gotoDir', 'toDir': toDir, 'whoami': 'client'}),
              );
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(color: ideckiaLayout.bgColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rows,
            ),
          ),
        ),
      )
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

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return Scaffold(
      body: StreamBuilder(
          stream: channel.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Log.debug(
                "Connection state: ${snapshot.connectionState} / hasData: ${snapshot.hasData} / hasError: ${snapshot.hasError}");
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                ),
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return fallbackWidget;
            }

            if (snapshot.hasData) {
              ServerMsg serverMsg =
                  ServerMsg.fromJson(jsonDecode(snapshot.data));
              if (serverMsg.type == 'layout') {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: createLayout(
                    IdeckiaLayout.fromJson(serverMsg.data),
                    context,
                  ),
                );
              }
            }

            return Center(
              child: CircularProgressIndicator(
                semanticsValue: tr('looking_for_server'),
              ),
            );
          }),
    );
  }
}
