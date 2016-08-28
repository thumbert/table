library nest;

/// Take a nested map [m] and return a one-level new map.
/// For example given the input map:
/// {
///   'foo1': {'bar1': v11, 'bar2': v12, ...},
///   'foo2': {'bar1': v21, 'bar2': v22, ...}
/// }
/// Return the flattened map as a List of Maps.
/// [{'foo': 'foo1', 'bar1': v11},
///  {'foo': 'foo1', 'bar2': v12},
///  {'foo': 'foo2', 'bar1': v21},
///  {'foo': 'foo2', 'bar2': v22}, ...]
///
List<Map> flattenMap(Map m, {List<String> levelNames}) {
  levelNames ??= [];
  return _flattenLevel([], m, 0, levelNames: levelNames)
      .toList(growable: false);
}

List _flattenLevel(List out, Map x, int level, {List<String> levelNames}) {
  if (levelNames.isEmpty || levelNames.length < level + 1) {
    levelNames.add('level$level');
  }
  String name = levelNames[level];

  x.keys.forEach((k) {
    if (level == 0) {
      out.add({name: k});
    } else {
      out = out.map((Map e) {
        e[name] = k;
        return e;
      }).toList();
    }

    if (x[k] is Map) {
      out = _flattenLevel(out, x[k], level + 1, levelNames: levelNames);
    } else {
      out = out.map((e) {
        e['value'] = x[k];
        return e;
      }).toList();
      /// row is done, add to out
      out.add(row);
    }
  });

  return out.toList();
}

/// WRONG
dynamic _flattenLevel2(dynamic x, int level, {List<String> levelNames}) {
  List<Map> res = [];

  /// keep flattening
  if (levelNames.isEmpty || levelNames.length < level + 1) {
    levelNames.add('level$level');
  }
  if (x is Map) {
    x.keys.forEach((k) {
      print('level: $level, name: ${levelNames[level]}, key: $k');
      print('x[k]: ${x[k]}');
      Map aux = _flattenLevel(x[k], level + 1, levelNames: levelNames);
      res.add({levelNames[level]: k}..addAll(aux));
    });
  } else {
    res.add({levelNames[level]: x});
  }

  return res;
}
