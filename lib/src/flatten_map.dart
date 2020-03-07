library flatten_map;

/// Given a multiple level nested Map, extract the values of the last level.
/// This function is useful to extract the results of a nest computation. 
List extractValues(Map x) {
  List out = [];
  if (x.values.first is List) {
    out.addAll(x.values);
  } else {
    x.forEach((k,v) {
      out.addAll(extractValues(v));
    });
  }
  return out;
}



/// Take a nested map [m] and return a List of maps.
/// For example given the input map:
///
/// {
///   'foo1': {'bar1': v11, 'bar2': v21, ...},
///   'foo2': {'bar1': v21, 'bar2': v22, ...}
/// }
///
/// Return the flattened map as a List of Maps.
///
/// [{'level0': 'foo1', 'level1': 'bar1', 'value': v11},
///  {'level0': 'foo1', 'level1': 'bar2', 'value': v12},
///  {'level0': 'foo2', 'level1': 'bar1', 'value': v21},
///  {'level0': 'foo2', 'level1': 'bar2', 'value': v22},
///  ...]
///
/// To unwrap only part of the nested map, specify fewer
/// [levelNames]. 
List<Map> flattenMap(Map m, List<String> levelNames) {
  if (levelNames.isEmpty) return [m];
  return _flatten(m, 0, levelNames);
}

List<Map> _flatten(Map m, int level, List levelNames) {
  List<Map> out;
  var name = levelNames[level];

  m.forEach((k, v) {
    if (level < levelNames.length-1 && v is Map) {
      out ??= <Map>[];
      var aux = _flatten(v, level + 1, levelNames);
      out.addAll(aux.map((Map e) => {name: k}..addAll(e)));
    } else {
      /// last level
      out ??= <Map>[];
      if (v is Map) {
        if (level == levelNames.length-1) {
          var _bux = {name: k}..addAll(v);
          out.add({name: k}..addAll(v));
        } else {
          v[name] = k;
          out.add(v);
        }
      } else {
        out.add({name: k, levelNames[level+1]: v});
      }
    }
  });
  return out;
}


