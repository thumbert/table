library unique;

import 'dart:collection';
import 'package:collection/collection.dart';

const _rowEquality = MapEquality();

/// Get the unique Map elements from a list.  If [keys] are specified, 
/// only the Map elements with the keys specified are returned. 
///
List<Map> unique(List<Map> xs, {List keys}) {
  Set<Map> uRows = LinkedHashSet(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (e) => _rowEquality.hash(e));
  if (keys == null) {
    for (var i = 0; i < xs.length; i++) {
      uRows.add(xs[i]);
    }
  } else {
    for (var i = 0; i < xs.length; i++) {
      var aux = Map.fromIterables(keys, keys.map((key) => xs[i][key]));
      uRows.add(aux);
    }
  }
  return uRows.toList();
}
