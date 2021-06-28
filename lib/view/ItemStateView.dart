import 'package:flutter/material.dart';
import 'package:ideckia/model/ItemState.dart';

class ItemStateView extends StatelessWidget {
  ItemStateView({
    Key key,
    this.itemState,
    this.buttonSize,
    this.buttonRadius,
    this.onClick,
    this.onLongPress,
  }) : super(key: key);
  final ItemState itemState;
  final Function(int) onClick;
  final Function(int) onLongPress;
  final double buttonSize;
  final double buttonRadius;
  //

  @override
  Widget build(BuildContext context) {
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
        decoration: itemState.iconData != null
            ? BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(itemState.iconData),
                  fit: BoxFit.scaleDown,
                ),
              )
            : null,
        height: buttonSize,
        width: buttonSize,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            itemState.text,
            style: TextStyle(
              fontSize: 20,
              color: itemState.textColor,
            ),
          ),
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
