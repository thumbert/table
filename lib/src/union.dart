library union;

import 'dart:collection';
import 'package:collection/collection.dart';

const _rowEquality = MapEquality();

/// Get the union of two tables.
List<Map> union(List<Map> xs, List<Map> ys) {
  Set<Map> uRows = LinkedHashSet(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (e) => _rowEquality.hash(e));

  for (var i = 0; i < xs.length; i++) {
    uRows.add(xs[i]);
  }

  for (var e in ys) {
    if (uRows.contains(e)) {
      continue;
    } else {
      uRows.add(e);
    }
  }

  return uRows.toList();
}
