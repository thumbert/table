
/// Add the missing columns for each of the rows of input [xs].  Fill with
/// the [fill] value.
List<Map<String,dynamic>> addMissing(List<Map<String,dynamic>> xs, {fill: null}) {
  // get the missing columns for each row
  var _columnNames = Set<String>();
  for (var row in xs) _columnNames.addAll(row.keys);

  var out = <Map<String, dynamic>>[];
  var columnNames = _columnNames.toList();
  for (var x in xs) {
    var row = <String, dynamic>{};
    for (var name in columnNames) {
      if (x.containsKey(name)) {
        row[name] = x[name];
      } else {
        row[name] = fill;
      }
    }
    out.add(row);
  }

  return out;
}

