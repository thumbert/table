library reshape;

import 'dart:collection';
import 'package:collection/collection.dart';

/// Reshape/pivot a list of maps.
/// Each element of input [xs] needs to have the same keys .
///
List<Map> reshape(List<Map<String, dynamic>> xs, List<String> vertical,
    List<String> horizontal, String variable, {fill: null}) {
  // group rows
  var _fg =
      (Map row) => new Map.fromIterables(vertical, vertical.map((g) => row[g]));
  var ind = _groupByIndex(xs, _fg);

  // the horizontal columns may need to be joined
  var horizontalVals = <String>[];
  if (horizontal.length == 1) {
    horizontalVals = xs.map((e) => e[horizontal.first].toString()).toList();
  } else {
    xs.forEach((row) {
      String str = horizontal.map((name) => row[name]).join('_');
      horizontalVals.add(str);
    });
  }

  var res = <Map<String, dynamic>>[];
  ind.forEach((k, List v) {
    var row = <String, dynamic>{};
    vertical.forEach((name) => row[name] = k[name]);
    v.forEach((i) => row[horizontalVals[i]] = xs[i][variable]);
    res.add(row);
  });

  return res;
}


/// Utility to group rows by a given function.
/// Each key of the resulting Map is the grouping value.
/// Each value of the resulting Map is a list of row indices.
///
/// It is a more memory efficient way to do the grouping.
/// Function [f] takes an element of the iterable and returns a grouping value.
/// In this case the Iterable x is the actual table.
Map<dynamic, List<int>> _groupByIndex(Iterable x, Function f) {
  const _rowEquality = const MapEquality();
  Map<dynamic, List<int>> result = new LinkedHashMap(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (e) => _rowEquality.hash(e));

  int ind = 0;
  x.forEach((row) {
    result.putIfAbsent(f(row), () => []).add(ind);
    ind += 1;
  });

  return result;
}

