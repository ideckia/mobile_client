import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ideckia/model/IdeckiaLayout.dart';
import 'package:ideckia/model/ItemState.dart';
import 'package:ideckia/view/ItemStateView.dart';

class IdeckiaLayoutView extends StatelessWidget {
  IdeckiaLayoutView({Key key, this.ideckiaLayout, this.onItemClick})
      : super(key: key);
  final IdeckiaLayout ideckiaLayout;
  final Function(int) onItemClick;

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
          buttonSize: buttonSize,
          buttonRadius: radius
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: createLayout(ideckiaLayout, context),
    );
  }
}
