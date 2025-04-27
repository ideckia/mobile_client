import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:ideckia/model/ItemState.dart';
import 'package:ideckia/model/StyledText.dart';

class ItemStateView extends StatelessWidget {
  ItemStateView({
    Key? key,
    required this.itemState,
    required this.buttonSize,
    required this.buttonRadius,
    required this.onPress,
    required this.onLongPress,
  }) : super(key: key);
  final ItemState itemState;
  final Function(int) onPress;
  final Function(int) onLongPress;
  final double buttonSize;
  final double buttonRadius;
  //

  @override
  Widget build(BuildContext context) {
    var iconData = itemState.iconData;

    var decoration = null;

    if (iconData != null) {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(buttonRadius),
        image: DecorationImage(
          image: getImageProvicer(iconData),
          fit: BoxFit.scaleDown,
        ),
      );
    }

    final child = Container(
      decoration: decoration,
      height: buttonSize,
      width: buttonSize,
      child: Align(
        alignment: itemState.textPosition == 'top'
            ? Alignment.topCenter
            : itemState.textPosition == 'center'
                ? Alignment.center
                : Alignment.bottomCenter,
        child: StyledText.get(itemState),
      ),
    );

    return MaterialButton(
      padding: EdgeInsets.all(8.0),
      textColor: itemState.textColor,
      color: itemState.bgColor,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonRadius),
      ),
      child: child,
      onPressed: () {
        onPress(itemState.id);
      },
      onLongPress: () {
        onLongPress(itemState.id);
      },
    );
  }

  ImageProvider getImageProvicer(String iconData) {
    if (iconData.contains('<svg')) {
      return Svg('', svgGetter: (key) async => iconData);
    } else {
      var decoded = base64Decode(iconData.split(',').last);
      if (iconData.contains('data:image/svg')) {
        return Svg('', svgGetter: (key) async => utf8.decode(decoded));
      } else {
        return MemoryImage(decoded);
      }
    }
  }
}
