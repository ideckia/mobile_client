import 'package:flutter/material.dart';
import 'package:ideckia/model/ItemState.dart';
import 'package:ideckia/model/RichString.dart';
import 'package:simple_rich_text/simple_rich_text.dart';

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

  List<RichString> extractRichStrings(text) {
    var detectorRreg = RegExp('\{([^\}]*)+[\}]+');
    var extractorEreg = RegExp('\{([^:]*):');

    List<RichString> extracted = [];
    if (detectorRreg.hasMatch(text)) {
      Iterable<RegExpMatch> matches = detectorRreg.allMatches(text);

      matches.forEach((match) {
        var detected = match.group(0) ?? '';
        Iterable<RegExpMatch> extractorMatches =
            extractorEreg.allMatches(detected);
        var rs = new RichString(matched: detected);
        var lastEnd;
        extractorMatches.forEach((extractorMatch) {
          var value = extractorMatch.group(1) ?? '';
          if (value == 'b') rs.bold = true;
          if (value == 'i') rs.italic = true;
          if (value == 'u') rs.underline = true;
          if (value.startsWith('color.')) {
            rs.color = value.replaceAll('color.', '');
          }
          if (value.startsWith('size.')) {
            rs.size = int.parse(value.replaceAll('size.', ''));
          }

          lastEnd = extractorMatch.end;
        });
        rs.text = detected.substring(lastEnd).replaceAll('}', '');

        extracted.add(rs);
      });
    }
    return extracted;
  }

  String createSimpleRichTextString(String text) {
    List<RichString> richStrings = extractRichStrings(text);

    richStrings.forEach((rs) {
      var richText = rs.text ?? '';
      if (rs.color != null || rs.size != null) {
        var obj = [];
        if (rs.color != null) obj.add('color:${rs.color}');
        if (rs.size != null) obj.add('fontSize:${rs.size}');
        richText = '~{${obj.join(',')}}$richText~';
      }
      if (rs.bold) richText = '*$richText*';
      if (rs.underline) richText = '_${richText}_';
      if (rs.italic) richText = '/$richText/';
      if (rs.matched != '') text = text.replaceAll(rs.matched, richText);
    });

    return text;
  }

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
          alignment: Alignment.bottomCenter,
          child: SimpleRichText(
            createSimpleRichTextString(itemState.text.replaceAll('/', '\\/')),
            style: TextStyle(
              fontSize: itemState.textSize,
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
