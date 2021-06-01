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
    
    var allNull = true;
    
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
    String text = '';
    if (json['text'] != null) {
      text = json['text'].toString();
      allNull = false;
    }
    
    if (allNull) {
      return ItemState.empty();
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
