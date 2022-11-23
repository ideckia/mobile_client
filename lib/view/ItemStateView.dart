import 'package:flutter/material.dart';
import 'package:ideckia/model/ItemState.dart';
import 'package:ideckia/model/StyledText.dart';

class ItemStateView extends StatelessWidget {
  ItemStateView({
    Key? key,
    required this.itemState,
    required this.buttonSize,
    required this.buttonRadius,
    required this.onClick,
    required this.onLongPress,
  }) : super(key: key);
  final ItemState itemState;
  final Function(int) onClick;
  final Function(int) onLongPress;
  final double buttonSize;
  final double buttonRadius;
  //

  @override
  Widget build(BuildContext context) {
    var iconData = itemState.iconData;
    return MaterialButton(
      padding: EdgeInsets.all(8.0),
      textColor: itemState.textColor,
      color: itemState.bgColor,
      splashColor: Colors.greenAccent,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonRadius),
      ),
      child: Container(
        decoration: iconData != null
            ? BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(iconData),
                  fit: BoxFit.scaleDown,
                ),
              )
            : null,
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
      ),
      onPressed: () {
        onClick(itemState.id);
      },
      onLongPress: () {
        onLongPress(itemState.id);
      },
    );
  }
}
