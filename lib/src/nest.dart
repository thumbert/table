library nest;


/// Implement a nest construct as in D3
class Nest {
  List<Function> _keys = [];
  //List _sortKeys = [];
  Function _rollup;

  Nest();

  /// Register the function [f] as a key to this nest object.  The key function will be
  /// invoked for each element in the input list and must return a string identifier
  /// to assign the element to its group.
  ///
  void key(Function f) {
    _keys.add(f);
  }

  /// Specifies a rollup function to be applied on each group of leaf elements. The
  /// return value of the rollup function will replace the array of leaf values in
  /// either the associative array returned by nest.map;
  /// for nest.entries, it replaces the leaf entry.values with entry.value.
  ///
  void rollup(Function f) {
    _rollup = f;
  }

  /// Group data according to the key functions. Input [data] is a list of maps.
  /// Each [key] function is applied recursively to the data.
  /// Return a List of maps.  For example for two key functions you should see
  /// [
  ///   {key: 'foo1', values: [{key: 'bar1', values: [...]}, ...]},
  ///   {key: 'foo2', values: [{key: 'bar1', values: [...]}, ...]},
  ///   ...
  /// ]
  /// If there is a roll function, it returns the result as the leaf of the nest.
  ///
  dynamic entries(List values) {
    return _entries(values, 0);
  }

  /// Group data according to the key functions. Input [data] is a list of maps.
  /// Each [key] function is applied recursively to the data to
  /// return a map.
  ///
  /// For example, with two key functions you should see
  ///  {
  ///    'foo1': {'bar1': [...], 'bar2': [...], ...},
  ///    'foo2': {'bar1': [...], 'bar2': [...], ...},
  ///    ...
  ///  }
  Map map(List<Map> values) {
    return _map(values, 0);
  }

  dynamic _map(List x, int depth) {
    if (depth >= _keys.length) return _rollup != null ? _rollup(x) : x;

    Map res = {};
    x.forEach((v) {
      var k = _keys[depth](v);
      res.putIfAbsent(k, () => []).add(v);
    });

    return new Map.fromIterables(
        res.keys, res.keys.map((k) => _map(res[k], depth + 1)));
  }


  dynamic _entries(List x, int depth) {
    if (depth >= _keys.length) return _rollup != null ? _rollup(x) : x;

    var res = <Map>[];
    x.forEach((v) {
      var k = _keys[depth](v);
      bool exists = false;
      int i = 0;
      // do I have a more efficient way to search that the key exists?
      for (Map g in res) {
        if (g['key'] == k) {
          exists = true;
          break;
        } else {
          i = i + 1;
        }
      }

      if (exists) {
        /// add v to the existing values list
        res[i]['values'].add(v);
      } else {
        /// create a new entry in the res List
        res.add({
          'key': k,
          'values': [v]
        });
      }
    });

    return res
        .map((Map g) =>
    {'key': g['key'], 'values': _entries(g['values'], depth + 1)})
        .toList();
  }
}
