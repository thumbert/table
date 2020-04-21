library reshape;

import 'dart:collection';
import 'package:collection/collection.dart';

/// Reshape/pivot a list of maps.
/// Each element of input [xs] needs to have the same keys.
/// Input [xs] is in the long format.  To bring a data set in the long format
/// use [melt].
///
/// [rows] is the list of variables that will remain as rows.
/// [columns] is the list of variables that will become columns.  Usually
/// [columns] is a single element list.
///
List<Map> reshape(List<Map<String, dynamic>> xs, List<String> rows,
    List<String> columns, String variable, {fill: null}) {
  // group rows
  var _fg =
      (Map row) => Map.fromIterables(rows, rows.map((g) => row[g]));
  var ind = _groupByIndex(xs, _fg);

  // the columns need to be joined, if more than 1
  var columnVals = <String>[];
  if (columns.length == 1) {
    columnVals = xs.map((e) => e[columns.first].toString()).toList();
  } else {
    xs.forEach((row) {
      var str = columns.map((name) => row[name]).join('_');
      columnVals.add(str);
    });
  }

  var _columnNames = <String>{...columnVals};

  var res = <Map<String, dynamic>>[];
  for (var entry in ind.entries) {
    var row = <String, dynamic>{};
    rows.forEach((name) => row[name] = entry.key[name]);
    for (var c in _columnNames) {
      row[c] = fill;
    }
    for (var e in entry.value) {
      row[columnVals[e]] = xs[e][variable];
    }

    res.add(row);
  }



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
  const _rowEquality = MapEquality();
  Map<dynamic, List<int>> result = LinkedHashMap(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (e) => _rowEquality.hash(e));

  var ind = 0;
  x.forEach((row) {
    result.putIfAbsent(f(row), () => []).add(ind);
    ind += 1;
  });

  return result;
}


