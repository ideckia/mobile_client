
import 'package:ideckia/model/ItemState.dart';

class IdeckiaLayout {
  final int rows;
  final int columns;
  final List<ItemState> items;
  const IdeckiaLayout(this.rows, this.columns, this.items);

  factory IdeckiaLayout.fromJson(Map<String, dynamic> json) {
    return IdeckiaLayout(
      json['rows'],
      json['columns'],
      (json['items'] as List).map((i) =>
              ItemState.fromJson(i)
            ).toList()
    );
  }
}