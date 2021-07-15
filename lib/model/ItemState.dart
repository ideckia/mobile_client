import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ItemState {
  final int id;
  final String text;
  final double textSize;
  final Color textColor;
  final Color bgColor;
  final Uint8List iconData;
  const ItemState(
    this.id,
    this.text,
    this.textSize,
    this.textColor,
    this.bgColor,
    this.iconData,
  );

  static final String defaultText = '';
  static final double defaultTextSize = 18;
  static final Color defaultTextColor = Colors.white;
  static final Color defaultbgColor = Colors.blueGrey.shade900;

  factory ItemState.fromJson(Map<String, dynamic> json) {
    var allNull = true;

    String text = defaultText;
    double textSize = defaultTextSize;
    if (json['text'] != null) {
      text = json['text'].toString();
      allNull = false;
      if (json['textSize'] != null) {
        textSize = json['textSize'].toDouble();
      }
    }
    Color textColor = defaultTextColor;
    if (json['textColor'] != null) {
      textColor = Color(int.parse(json['textColor'], radix: 16));
      allNull = false;
    }
    Color bgColor = defaultbgColor;
    if (json['bgColor'] != null) {
      bgColor = Color(int.parse(json['bgColor'], radix: 16));
      allNull = false;
    }
    Uint8List iconData;
    if (json['icon'] != null) {
      var iconBase64 = json['icon'].toString();
      iconData = base64Decode(iconBase64);
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
      bgColor,
      iconData,
    );
  }

  factory ItemState.empty() {
    return ItemState(
      -1,
      defaultText,
      defaultTextSize,
      defaultTextColor,
      defaultbgColor,
      null,
    );
  }
}
