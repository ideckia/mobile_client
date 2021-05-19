import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ItemState {
  final int id;
  final String text;
  final Color textColor;
  final Uint8List iconData;
  final Color bgColor;
  const ItemState(
      this.id, this.text, this.textColor, this.iconData, this.bgColor);

  factory ItemState.fromJson(Map<String, dynamic> json) {
    Color textColor = Colors.white;
    if (json['textColor'] != null) {
      textColor = Color(int.parse(json['textColor'], radix: 16));
    }
    Color bgColor = Colors.blueGrey.shade900;
    if (json['bgColor'] != null) {
      bgColor = Color(int.parse(json['bgColor'], radix: 16));
    }
    Uint8List iconData;
    if (json['icon'] != null) {
      var iconBase64 = json['icon'].toString();
      iconData = base64Decode(iconBase64);
    }
    String text = '';
    if (json['text'] != null) {
      text = json['text'].toString();
    }

    return ItemState(
      json['id'],
      text,
      textColor,
      iconData,
      bgColor,
    );
  }

  factory ItemState.empty() {
    return ItemState(-1, '', Colors.white, null, Colors.grey);
  }
}
