library reshape;

/// Reshape/pivot a list of maps.
/// Each element of input [xs] needs to have the same keys .
///
List<Map> reshape(List<Map<String, dynamic>> xs, List<String> vertical,
    List<String> horizontal, String variable, {fill: null}) {
  // group rows
  var _fg =
      (Map row) => new Map.fromIterables(vertical, vertical.map((g) => row[g]));
  var ind = _groupByIndex(xs, _fg);

  // the horizontal columns may need to be joined
  var horizontalVals = <String>[];
  if (horizontal.length == 1) {
    horizontalVals = xs.map((e) => e[horizontal.first].toString()).toList();
  } else {
    xs.forEach((row) {
      String str = horizontal.map((name) => row[name]).join('_');
      horizontalVals.add(str);
    });
  }

  var res = <Map<String, dynamic>>[];
  ind.forEach((k, List v) {
    var row = <String, dynamic>{};
    vertical.forEach((name) => row[name] = k[name]);
    v.forEach((i) => row[horizontalVals[i]] = xs[i][variable]);
    res.add(row);
  });

  return res;
}
