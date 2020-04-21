library reorder_columns;

/// Return a new collection of rows which contains only the columns
/// specified in [columnNames].  If a column doesn't exist throw an error.
List<Map<String, dynamic>> reorderColumns(
    List<Map<String, dynamic>> xs, List columnNames) {
  var out = <Map<String, dynamic>>[];
  for (var x in xs) {
    var row = <String, dynamic>{};
    for (var name in columnNames) {
      if (!x.containsKey(name)) {
        throw ArgumentError('Column $name doesn\'t exist in $x');
      }
      row[name] = x[name];
    }
    out.add(row);
  }
  return out;
}
