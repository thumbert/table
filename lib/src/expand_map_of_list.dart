library expand_map_of_list;

import 'package:table/src/collapse_list_of_map.dart';

/// Go from a map of [List]s to a list of [Map]s.  This function is the opposite 
/// of [collapseListOfMap].
///
/// E.g. given input
/// ```{'code': ['BWI', 'BOS', 'BWI'], 'value': [15, 17, 25]} ```
///
/// Return
/// ```
/// [
///   {'code': 'BWI', 'value': 15},
///   {'code': 'BOS', 'value': 17},
///   {'code': 'BWI', 'value': 25},
/// ];
/// ```
List<Map<String,dynamic>> expandMapOfList(Map<String,List> x,
    {List<String> columns}) {
  columns ??= x.keys.toList();
  var out = <Map<String,dynamic>>[];
  int n = x[columns.first].length;
  var equalLengths = x.values.map((e) => e.length).every((e) => e == n);
  if (!equalLengths)
    throw ArgumentError('Not all keys have the same number of elements.');

  for (int i=0; i<n; i++) {
    var values = [];
    for (var column in columns) {
      values.add(x[column][i]);
    }
    out.add(Map.fromIterables(columns, values));
  }
  return out;
}


@Deprecated('Replaced by expandMapOfList')
List<Map<String,dynamic>> columnsToRows(Map<String,List> xs) {
  return expandMapOfList(xs);
}

