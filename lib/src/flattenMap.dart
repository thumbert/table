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
  return _flattenLevel(m, 0, levelNames: levelNames);
}




dynamic _flattenLevel(Map x, {List<String> levelNames}) {
  List<Map> res = [];
  int level = 0;

  x.keys.forEach((k) {
    if (levelNames.isEmpty || levelNames.length < level+1) {
      levelNames.add('level$level');
    }
    Map row = {levelNames[level]: x[k]};



  });


  /// keep flattening
  if (x is Map) {
    x.keys.forEach((k) {
      print('level: $level, name: ${levelNames[level]}, key: $k');
      print('x[k]: ${x[k]}');
      Map aux = _flattenLevel(x[k], level+1, levelNames: levelNames);
      res.add({levelNames[level]: k}..addAll(aux));
    });
  } else {
    res.add({levelNames[level]: x});
  }

  return res;
}




/// WRONG
dynamic _flattenLevel2(dynamic x, int level, {List<String> levelNames}) {
  List<Map> res = [];
  /// keep flattening
  if (levelNames.isEmpty || levelNames.length < level+1) {
    levelNames.add('level$level');
  }
  if (x is Map) {
    x.keys.forEach((k) {
      print('level: $level, name: ${levelNames[level]}, key: $k');
      print('x[k]: ${x[k]}');
      Map aux = _flattenLevel(x[k], level+1, levelNames: levelNames);
      res.add({levelNames[level]: k}..addAll(aux));
    });
  } else {
    res.add({levelNames[level]: x});
  }

  return res;
}



