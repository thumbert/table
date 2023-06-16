library join;

import 'dart:collection';
import 'package:collection/collection.dart';
import 'table_base.dart';

const _rowEquality = MapEquality();

/// Join in SQL sense two table like Lists by the common columns in
/// each table.  Both tables are considered to be in "rectangular shape"
/// (not have missing columns.)
///
/// Argument [byColumns] allows you to explicitly indicate which columns
/// to use for the join.  Be default, use the common columns in each tables.
///
/// If a function [f] is passed as an argument, new columns can be calculated.
///
List<Map<String, dynamic>> join<K>(
    List<Map<String, dynamic>> x, List<Map<String, dynamic>> y,
    {JoinType joinType = JoinType.inner,
    List<String>? byColumns,
    List<MapEntry<String, K>> Function(
            Map<String, dynamic>, Map<String, dynamic>)?
        f}) {
  var _xCols = x.first.keys;
  var _yCols = y.first.keys;
  byColumns ??= _xCols.toSet().intersection(_yCols.toSet()).toList();

  if (byColumns.isEmpty) {
    throw ArgumentError('No common column names between the two tables.');
  }

  // split each table into groups of rows with same common by values
  var g1 = _groupBy(
      x,
      (e) => Map.fromIterables(byColumns!,
          List.generate(byColumns.length, (i) => e[byColumns![i]])));
  var g2 = _groupBy(
      y,
      (e) => Map.fromIterables(byColumns!,
          List.generate(byColumns.length, (i) => e[byColumns![i]])));

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
              if (!byColumns!.contains(k)) e[k] = v;
            });
          } else {
            e = {for (var k in byColumns!) k: v1[k]};
            e.addEntries(f(v1, v2));
          }
          res.add(e);
        }
      }
    }
  }

  void _addLeftOnlyRows() {
    // filler for the missing columns in this other table; the columns in other that are not in by
    var rKeys = _yCols.toSet().difference(byColumns!.toSet()).toList();
    var rFill = Map.fromIterables(rKeys, List.filled(rKeys.length, null));
    // loop only over the keys that are missing in other table
    for (var group in g1k.difference(g2k)) {
      for (Map<String,dynamic> v1 in g1[group]) {
        if (f == null) {
          // as the key is not there, add nulls for the missing variables in other
          res.add(Map<String, dynamic>.from(v1)..addAll(rFill));
        } else {
          res.add(Map<String, dynamic>.from(group!)..addEntries(f(v1, {})));
        }
      }
    }
  }

  void _addRightOnlyRows() {
    // filler for the missing columns in this table; the columns in this that are not in by
    var lKeys = _xCols.toSet().difference(byColumns!.toSet()).toList();
    var lFill = Map.fromIterables(lKeys, List.filled(lKeys.length, null));
    // loop only over the keys that are missing in this table
    for (var group in g2k.difference(g1k)) {
      for (Map<String,dynamic> v2 in g2[group]) {
        if (f == null) {
          // if the key is not there, add nulls for the missing variables in this
          res.add(Map<String, dynamic>.from(v2)..addAll(lFill));
        } else {
          res.add(Map<String, dynamic>.from(group!)..addEntries(f({}, v2)));
        }
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
