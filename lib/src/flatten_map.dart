library flatten_map;

/// Given a multiple level nested Map, extract the values of the last level.
/// This function is useful to extract the results of a nest computation.
List extractValues(Map x) {
  var out = [];
  if (x.values.first is List) {
    out.addAll(x.values);
  } else {
    x.forEach((k, v) {
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
List<Map<String, dynamic>>? flattenMap(Map m, List<String> levelNames) {
  if (levelNames.isEmpty) return [m as Map<String, dynamic>];
  return _flatten(m, 0, levelNames);
}

List<Map<String, dynamic>>? _flatten(
    Map m, int level, List<String> levelNames) {
  List<Map<String, dynamic>>? out;
  var name = levelNames[level];

  m.forEach((k, v) {
    if (level < levelNames.length - 1 && v is Map) {
      out ??= <Map<String, dynamic>>[];
      var aux = _flatten(v, level + 1, levelNames)!;
      out!.addAll(
          aux.map((Map e) => {name: k}..addAll(e as Map<String, dynamic>)));
    } else {
      /// last level
      out ??= <Map<String, dynamic>>[];
      if (v is Map) {
        if (level == levelNames.length - 1) {
          var row = <String, dynamic>{name: k, ...v};
          out!.add(row);
        } else {
          v[name] = k;
          out!.add(v as Map<String, dynamic>);
        }
      } else {
        out!.add({name: k, levelNames[level + 1]: v});
      }
    }
  });
  return out;
}
