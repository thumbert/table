library rename_columns;

/// Rename columns.  Specify only the columns you are interested in
/// renaming.  The columns that don't match the keys in
/// the [fromTo] map will be left unchanged.
///
List<Map<String, dynamic>> renameColumns(
    List<Map<String, dynamic>> xs, Map<String, String> fromTo) {
  var out = <Map<String, dynamic>>[];
  var fromKeys = Set.from(fromTo.keys);
  for (var x in xs) {
    var row = <String, dynamic>{};
    x.keys.forEach((k) {
      if (fromKeys.contains(k)) {
        row[fromTo[k]!] = x[k];
      } else {
        row[k] = x[k];
      }
    });
    out.add(row);
  }
  return out;
}
