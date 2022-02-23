class RichString {
  bool bold = false;
  bool italic = false;
  bool underline = false;
  int? size;
  String? color;
  String? text;
  String matched;

  RichString({required this.matched});

  @override
  String toString() {
    var st = '{\n';
    st += '  text: $text,\n';
    st += '  bold: $bold,\n';
    st += '  italic: $italic,\n';
    st += '  underline: $underline,\n';
    st += '  size: $size,\n';
    st += '  color: $color,\n';
    st += '  matched: $matched,\n';
    st += '}';
    return st;
  }
}
