library nest;

/// Take a nested map [m] and return a one-level new map.
/// For example given the input map:
/// {
///   'foo1': {'bar1': v11, 'bar2': v12, ...},
///   'foo2': {'bar1': v21, 'bar2': v22, ...}
/// }
/// Return the flattened map as a List of Maps.
/// [{'level0': 'foo1', 'level1': 'bar1', 'value': v11},
///  {'level0': 'foo1', 'level1': 'bar2', 'value': v12},
///  {'level0': 'foo2', 'level1': 'bar1', 'value': v21},
///  {'level0': 'foo2', 'level1': 'bar2', 'value': v22},
///  ...]
///
List<Map> flattenMap(Map m, {List<String> levelNames}) {
  levelNames ??= [];
  return _flatten(m, 0).toList();
}

List _flatten(Map m, int level) {
  List out;
  m.forEach((k, v) {
    if (v is Map) {
      out ??= [];
      List aux = _flatten(v, level + 1);
      out.addAll(aux.map((Map e) {
        e['level$level'] = k;
        return e;
      }));
    } else {
      out ??= [];
      out.add({'value': v, 'level$level': k});
    }
  });
  return out;
}
