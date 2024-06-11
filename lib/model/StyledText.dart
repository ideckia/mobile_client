import 'package:ideckia/model/ItemState.dart';
import 'package:recursive_regex/recursive_regex.dart';
import 'package:flutter/material.dart';

class StyledText {
  bool bold = false;
  bool italic = false;
  bool underline = false;
  int? size;
  List<String>? emojis;
  String? color;
  String? styleControl;
  String text;
  List<StyledText>? children;

  StyledText({required this.text}) {
    this.children = [];
  }

  static Text get(ItemState itemState) {
    var baseStyle = TextStyle(
      fontSize: itemState.textSize,
      height: 1,
      color: itemState.textColor,
    );
    var text = itemState.text;

    final regex = RecursiveRegex(
      startDelimiter: RegExp(r'{'),
      endDelimiter: RegExp(r'}'),
      global: true,
      captureGroupName: 'group',
    );
    List<RegExpMatch> allMatches = regex.allMatches(text);

    var mainStyledText = StyledText(text: text);
    List<StyledText> all = [mainStyledText];
    for (var i = allMatches.length - 1; i >= 0; i--) {
      all.add(StyledText(text: allMatches[i].group(1)!));
    }

    // sort to get the shortest first
    all.sort((a, b) => a.text.length.compareTo(b.text.length));

    // create the StyledTexts tree
    for (var styledText in all) {
      for (var posibleParent in all) {
        if (styledText != posibleParent &&
            posibleParent.text.contains(styledText.text)) {
          posibleParent.children!.add(styledText);
          break;
        }
      }
    }

    sortChildren(mainStyledText);

    return Text.rich(
      createTextSpanTree(mainStyledText),
      style: baseStyle,
    );
  }

  static void sortChildren(StyledText styledText) {
    if (styledText.children == null || styledText.children!.isEmpty) return;

    styledText.children!.forEach((child) {
      sortChildren(child);
    });

    styledText.children!.sort((a, b) => styledText.text
        .indexOf(a.text)
        .compareTo(styledText.text.indexOf(b.text)));
  }

  static TextSpan createTextSpanTree(StyledText styledText) {
    if (styledText.children == null || styledText.children!.isEmpty)
      return processModificators(
          styledText.text.replaceAll('{', '').replaceAll('}', ''), null);

    List<InlineSpan> children = [];
    var beginIndex = 0;
    var firstSub;
    var sub;
    for (var i in styledText.children!) {
      var iIndex = styledText.text.indexOf(i.text);
      sub = styledText.text.substring(beginIndex, iIndex - 1);
      if (firstSub == null) {
        firstSub = sub;
      } else {
        if (sub.trim() != '') children.add(processModificators(sub, null));
      }
      beginIndex = iIndex + i.text.length + 1;
      children.add(createTextSpanTree(i));
    }

    if (styledText.text.length > beginIndex) {
      var sub = styledText.text.substring(beginIndex, styledText.text.length);
      if (sub.trim() != '') children.add(processModificators(sub, null));
    }
    if (firstSub.trim() != '')
      return processModificators(firstSub, children);
    else
      return TextSpan(children: children);
  }

  static TextSpan processModificators(text, List<InlineSpan>? children) {
    var style = TextStyle();
    var finalText = text;
    var styleControl = text;

    var isControl = text.startsWith('b:') ||
        text.startsWith('i:') ||
        text.startsWith('u:') ||
        text.startsWith('color.') ||
        text.startsWith('size.');
    if (isControl) {
      var colonIndex = text.indexOf(':');
      styleControl = text.substring(0, colonIndex);
      finalText = text.substring(colonIndex + 1, text.length);
    }

    if (styleControl == 'b')
      style = style.copyWith(fontWeight: FontWeight.bold);
    if (styleControl == 'i')
      style = style.copyWith(fontStyle: FontStyle.italic);
    if (styleControl == 'u')
      style = style.copyWith(decoration: TextDecoration.underline);
    if (styleControl.startsWith('emoji.')) {
      var emojis = text.replaceAll('emoji.', '').split(',');
      finalText = '';
      emojis.forEach((emoji) {
        finalText += String.fromCharCode(int.parse(emoji.trim(), radix: 16));
      });
    }
    if (styleControl.startsWith('color.')) {
      var colorString = styleControl.replaceAll('color.', '');
      var hexColor = int.parse('0xff' + colorString.substring(0, 6));
      style = style.copyWith(color: Color(hexColor));
    }
    if (styleControl.startsWith('size.')) {
      var size = double.parse(styleControl.replaceAll('size.', ''));
      style = style.copyWith(fontSize: size);
    }

    return TextSpan(
      text: finalText,
      children: children,
      style: style,
    );
  }

  @override
  String toString() {
    var st = '{\n';
    st += '  text: $text,\n';
    st += '  bold: $bold,\n';
    st += '  italic: $italic,\n';
    st += '  underline: $underline,\n';
    st += '  size: $size,\n';
    st += '  emojis: $emojis,\n';
    st += '  color: $color,\n';
    st += '}';
    return st;
  }
}
