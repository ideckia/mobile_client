import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'IdeckiaLayout.dart';

class ItemState {
  final int id;
  final String text;
  final double textSize;
  final Color textColor;
  final String textPosition;
  final Color bgColor;
  final Uint8List? iconData;
  const ItemState(
    this.id,
    this.text,
    this.textSize,
    this.textColor,
    this.textPosition,
    this.bgColor,
    this.iconData,
  );

  static const String DEFAULT_TEXT = '';
  static const double DEFAULT_TEXT_SIZE = 18;
  static const Color DEFAULT_TEXT_COLOR = Colors.white;
  static const String DEFAULT_TEXT_POSITION = 'bottom';
  static final Color defaultbgColor = Colors.blueGrey.shade900;

  factory ItemState.fromJson(Map<String, dynamic> json) {
    var allNull = true;

    String text = DEFAULT_TEXT;
    double textSize = DEFAULT_TEXT_SIZE;
    if (json['text'] != null) {
      text = json['text'].toString();
      allNull = false;
      if (json['textSize'] != null) {
        textSize = json['textSize'].toDouble();
      }
    }
    Color textColor = DEFAULT_TEXT_COLOR;
    if (json['textColor'] != null) {
      textColor = Color(int.parse(json['textColor'], radix: 16));
      allNull = false;
    }
    String textPosition = DEFAULT_TEXT_POSITION;
    if (json['textPosition'] != null) {
      textPosition = json['textPosition'];
      allNull = false;
    }
    Color bgColor = defaultbgColor;
    if (json['bgColor'] != null) {
      bgColor = Color(int.parse(json['bgColor'], radix: 16));
      allNull = false;
    }
    Uint8List? iconData;
    if (json['icon'] != null) {
      var iconBase64 = IdeckiaLayout.icons[json['icon']];
      iconData = base64Decode(iconBase64.split(',').last);
      allNull = false;
    }

    if (allNull) {
      return ItemState.empty();
    }

    return ItemState(
      json['id'],
      text,
      textSize,
      textColor,
      textPosition,
      bgColor,
      iconData,
    );
  }

  factory ItemState.empty() {
    return ItemState(
      -1,
      DEFAULT_TEXT,
      DEFAULT_TEXT_SIZE,
      DEFAULT_TEXT_COLOR,
      DEFAULT_TEXT_POSITION,
      defaultbgColor,
      null,
    );
  }
}
