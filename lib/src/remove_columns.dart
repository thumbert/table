library remove_columns;

/// Remove columns.  Specify the columns you want to remove.
List<Map<String, dynamic>> removeColumns(
    List<Map<String, dynamic>> xs, List<String> remove) {
  var out = <Map<String, dynamic>>[];
  for (var x in xs) {
    for (var name in remove) {
      x.remove(name);
    }
    out.add({...x});
  }
  return out;
}
