library aggregate;

import 'dart:collection';
import 'package:collection/collection.dart';

/// Aggregate a table-like list of Map.
/// [groupBy] are the variables the grouping is done.  If [groupBy] is empty,
/// apply the function [f] to all rows.
/// [variables] are the variables the aggregation function [f] is applied to.
List<Map<String,dynamic>> aggregate<K>(List<Map<String,dynamic>> xs,
  List<String> groupBy, List<String> variables,
    K Function(Iterable<K>) f) {
  if (variables.isEmpty) throw ArgumentError('Variables list cannot be empty');

  var res = <Map<String,dynamic>>[];
  if (groupBy.isEmpty) {
    var row = <String,dynamic>{};
    for (var variable in variables) {
      row[variable] = f(xs.map((e) => e[variable] as K));
    }
    res.add(row);
  } else {
    var groups = _indexByColumns(xs, groupBy);
    for (var entry in groups.entries) {
      var row = <String,dynamic>{}..addAll(entry.key);
      for (var variable in variables) {
        var zs = entry.value.map((i) => xs[i][variable] as K);
        row[variable] = f(zs);
      }
      res.add(row);
    }
  }

  return res;
}


/// Group elements of a table according to a list of columns.
Map<Map<String,dynamic>, List<Map<String,dynamic>>> groupByColumns(List<Map<String,dynamic>> xs,
    List<String> columns) {
  const _rowEquality = MapEquality();
  Map<Map<String,dynamic>, List<Map<String,dynamic>>> result = LinkedHashMap(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (e) => _rowEquality.hash(e));

  var f = (Map<String,dynamic> e) => { for (var column in columns) column : e[column] };

  var ind = 0;
  for (var row in xs) {
    result.putIfAbsent(f(row), () => []).add(xs[ind]);
    ind += 1;
  }

  return result;
}


/// Index elements of a table according to a list of columns.
Map<dynamic, List<int>> _indexByColumns(Iterable<Map<String,dynamic>> xs,
    List<String> columns) {
  var f = (Map<String,dynamic> e) => { for (var column in columns) column : e[column] };
  return _groupByIndex(xs, f);
}



/// Utility to group rows by a given function.
/// Each key of the resulting Map is the grouping value.
/// Each value of the resulting Map is a list of row indices.
///
/// It is a more memory efficient way to do the grouping.
/// Function [f] takes an element of the iterable and returns a grouping value.
/// Iterable [xs] is the data you want to split into distinct groups.
Map<dynamic, List<int>> _groupByIndex(Iterable<Map<String,dynamic>> xs,
    dynamic Function(Map<String,dynamic>) f) {
  const _rowEquality = MapEquality();
  Map<dynamic, List<int>> result = LinkedHashMap(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (e) => _rowEquality.hash(e));

  var ind = 0;
  for (var row in xs) {
    result.putIfAbsent(f(row), () => []).add(ind);
    ind += 1;
  }

  return result;
}
