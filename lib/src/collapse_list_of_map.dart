library collapse_list_of_map;

/// Go from a list of row-like data to a column-like map.
/// Allows you to "flatten" multiple rows into columnar data.
/// This function is the opposite of [expandMapOfList].
/// If [columns] is specified, only these columns will be collapsed.
///
/// E.g. given input
/// ```
/// xs = [
///   {'code': 'BWI', 'value': 15},
///   {'code': 'BOS', 'value': 17},
///   {'code': 'BWI', 'value': 25},
/// ];
/// ```
/// Return ```{'code': ['BWI', 'BOS', 'BWI'], 'value': [15, 17, 25]}```
///
Map<String, List> collapseListOfMap(List<Map<String,dynamic>> xs,
    {List<String> columns}) {
  if (xs.isEmpty) return <String,List>{};
  columns ??= xs.first.keys.toList();
  var out = Map.fromIterables(columns,
      List.generate(columns.length, (i) => []));
  for (var x in xs) {
    for (var column in columns) {
      if (!x.containsKey(column)) {
        throw ArgumentError('Row $x does not contain column $column');
      }
      out[column].add(x[column]);
    }
  }
  return out;
}

@Deprecated('Replaced by collapseListOfMap')
Map<String, List> rowsToColumns(List<Map<String,dynamic>> xs,
    {List<String> columns}) {
  return collapseListOfMap(xs, columns: columns);
}
