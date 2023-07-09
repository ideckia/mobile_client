import 'package:flutter/material.dart';
import 'package:ideckia/model/ItemState.dart';

class IdeckiaLayout {
  final int rows;
  final int columns;
  final Color bgColor;
  static Map icons = new Map();
  final List<ItemState> items;
  final List<ItemState> fixedItems;
  const IdeckiaLayout(
    this.rows,
    this.columns,
    this.bgColor,
    this.items,
    this.fixedItems,
  );

  static const Color DEFAULT_BG_COLOR = Color(0x00000000);

  factory IdeckiaLayout.fromJson(Map<String, dynamic> json) {
    var fixedItems = (json['fixedItems'] as List);

    icons = (json['icons'] as Map);
    Color bgColor = DEFAULT_BG_COLOR;
    if (json['bgColor'] != null) {
      bgColor = Color(int.parse(json['bgColor'], radix: 16));
    }

    return IdeckiaLayout(
      json['rows'],
      json['columns'],
      bgColor,
      (json['items'] as List).map((i) => ItemState.fromJson(i)).toList(),
      fixedItems.map((i) => ItemState.fromJson(i)).toList(),
    );
  }
}
