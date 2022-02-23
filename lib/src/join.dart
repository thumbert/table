library join;

import 'dart:collection';
import 'package:collection/collection.dart';
import 'table_base.dart';

const _rowEquality = MapEquality();

/// Join in SQL sense two table like Lists by the common columns in
/// each table.  Both tables are considered to be in "rectangular shape"
/// (not have missing columns.)
///
/// If a function [f] is passed as an argument, new columns can be calculated.
///
List<Map<String, dynamic>> join<K>(
    List<Map<String, dynamic>> x, List<Map<String, dynamic>> y,
    {JoinType joinType = JoinType.inner,
    List<MapEntry<String, K>> Function(
            Map<String, dynamic>, Map<String, dynamic>)?
        f}) {
  var _xCols = x.first.keys;
  var _yCols = y.first.keys;
  var by = _xCols.toSet().intersection(_yCols.toSet()).toList();

  if (by.isEmpty) {
    throw ArgumentError('No common column names between the two tables.');
  }

  // split each table into groups of rows with same common by values
  var g1 = _groupBy(x,
      (e) => Map.fromIterables(by, List.generate(by.length, (i) => e[by[i]])));
  var g2 = _groupBy(y,
      (e) => Map.fromIterables(by, List.generate(by.length, (i) => e[by[i]])));

  var g1k = LinkedHashSet(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (dynamic e) => _rowEquality.hash(e));
  g1k.addAll(g1.keys as Iterable<Map<dynamic, dynamic>?>);
  var g2k = LinkedHashSet(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (dynamic e) => _rowEquality.hash(e));
  g2k.addAll(g2.keys as Iterable<Map<dynamic, dynamic>?>);

  var res = <Map<String, dynamic>>[];

  void _addInnerRows() {
    // common keys
    var gCommon = g1k.intersection(g2k);
    for (var group in gCommon) {
      for (var v1 in g1[group]) {
        for (var v2 in g2[group]) {
          Map<String, dynamic> e;
          if (f == null) {
            e = Map<String, dynamic>.from(v1);
            v2.forEach((k, v) {
              if (!by.contains(k)) e[k] = v;
            });
          } else {
            e = {for (var k in by) k: v1[k]};
            e.addEntries(f(v1, v2));
          }
          res.add(e);
        }
      }
    }
  }

  void _addLeftOnlyRows() {
    // filler for the missing columns in this other table; the columns in other that are not in by
    var rKeys = _yCols.toSet().difference(by.toSet()).toList();
    var rFill = Map.fromIterables(rKeys, List.filled(rKeys.length, null));
    // loop only over the keys that are missing in other table
    for (var group in g1k.difference(g2k)) {
      for (Map v1 in g1[group]) {
        // as the key is not there, add nulls for the missing variables in other
        res.add(Map<String, dynamic>.from(v1)..addAll(rFill));
      }
    }
  }

  void _addRightOnlyRows() {
    // filler for the missing columns in this table; the columns in this that are not in by
    var lKeys = _xCols.toSet().difference(by.toSet()).toList();
    var lFill = Map.fromIterables(lKeys, List.filled(lKeys.length, null));
    // loop only over the keys that are missing in this table
    for (var group in g2k.difference(g1k)) {
      for (Map v2 in g2[group]) {
        // if the key is not there, add nulls for the missing variables in this
        res.add(Map<String, dynamic>.from(v2)..addAll(lFill));
      }
    }
  }

  switch (joinType) {
    case JoinType.inner:
      _addInnerRows();
      break;
    case JoinType.outer:
      _addInnerRows();
      _addLeftOnlyRows();
      _addRightOnlyRows();
      break;
    case JoinType.left:
      _addInnerRows();
      _addLeftOnlyRows();
      break;
    case JoinType.right:
      _addInnerRows();
      _addRightOnlyRows();
      break;
  }

  return res;
}

LinkedHashMap _groupBy(Iterable<Map<String, dynamic>> x, Function f) {
  var result = LinkedHashMap(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (dynamic e) => _rowEquality.hash(e));
  x.forEach((v) => result.putIfAbsent(f(v), () => []).add(v));

  return result;
}
