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

  factory ItemState.fromJson(Map<String, dynamic> json) {
    var allNull = true;

    String text = '';
    if (json['text'] != null) {
      text = json['text'].toString();
      allNull = false;
    }
    double textSize = 18;
    if (json['textSize'] != null) {
      textSize = json['textSize'].toDouble();
      allNull = false;
    }
    Color textColor = Colors.white;
    if (json['textColor'] != null) {
      textColor = Color(int.parse(json['textColor'], radix: 16));
      allNull = false;
    }
    Color bgColor = Colors.blueGrey.shade900;
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
    return ItemState(-1, '', 15, Colors.white, Colors.grey, null);
  }
}
