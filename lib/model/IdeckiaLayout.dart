import 'package:ideckia/model/ItemState.dart';

class IdeckiaLayout {
  final int rows;
  final int columns;
  final List<ItemState> items;
  final List<ItemState> fixedItems;
  const IdeckiaLayout(this.rows, this.columns, this.items, this.fixedItems);

  factory IdeckiaLayout.fromJson(Map<String, dynamic> json) {
    var fixedItems = (json['fixedItems'] as List);
    if (fixedItems == null) fixedItems = [];

    return IdeckiaLayout(
      json['rows'],
      json['columns'],
      (json['items'] as List).map((i) => ItemState.fromJson(i)).toList(),
      fixedItems.map((i) => ItemState.fromJson(i)).toList(),
    );
  }
}
