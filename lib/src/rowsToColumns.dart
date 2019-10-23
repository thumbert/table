
/// Go from a list of row-like data to a column-like map.
/// Allows you to "flatten" multiple rows into columnar data.
Map<String, List> rowsToColumns(List<Map<String,dynamic>> xs) {
  var columns = xs.first.keys.toSet();
  var out = Map.fromIterables(columns,
      List.generate(columns.length, (i) => []));
  for (var x in xs) {
    for (var column in columns) {
      if (!x.containsKey(column))
        throw ArgumentError('Row $x does not contain column $column');
      out[column].add(x[column]);
    }
  }
  return out;
}

