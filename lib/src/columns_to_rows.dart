library columns_to_rows;

/// Go from a map of column like data to a list of rows.
List<Map<String,dynamic>> columnsToRows(Map<String,List> xs) {
  var columns = xs.keys.toList(); 
  var out = <Map<String,dynamic>>[];
  int n = xs[columns.first].length;
  var equalLengths = xs.values.map((e) => e.length).every((e) => e == n);
  if (!equalLengths)
    throw ArgumentError('Not all keys have the same number of elements.');

  for (int i=0; i<n; i++) {
    var values = [];
    for (var column in columns) {
      values.add(xs[column][i]);
    }
    out.add(Map.fromIterables(columns, values));
  }
  return out;
}

