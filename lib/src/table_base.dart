// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


library table.base;

import 'dart:collection';
import 'dart:math';
import 'package:collection/equality.dart';
import 'package:more/ordering.dart';


enum JOIN_TYPE {
  OUTER_JOIN,
  LEFT_JOIN,
  RIGHT_JOIN,
  INNER_JOIN
}

class Column<E> {
  List<E> data;
  String name;

  Column(List this.data, String this.name);

  E operator [](int i) => data[i];

  operator []=(int i, E value) => data[i] = value;

  List toList() => data;

  Iterable<String> _paddedOutput() {
    List aux = [name]..addAll(data.map((e) => e.toString()));
    int width = aux.fold(0, (prev, e) => max(prev, e.length));
    return aux.map((String e) => e.padLeft(width));
  }

  String toString() => _paddedOutput().join('\n');

}


/**
 * A tabular view of columnar data iterable by row.
 */
class Table extends Object with IterableMixin<Map>{
  List<Column> _data = [];
  List<String> _colnames = [];
  static const _rowEquality = const MapEquality();

  /**
   * A table to hold observations of different variables.  Each variable is stored
   * in a [Column].
   *
   * Conceptually, there are two types
   * of variables: categorical/classification variables and measurement variables.  For example,
   * a categorical variable may be an airport code, and a measurement variable the daily max
   * temperature at that location.
   *
   * The null value is used to indicate missing data only.
   */
  Table({List<String> colnames}) {
    if (colnames != null) {
      _colnames = colnames;
      _colnames.forEach((name) => _data.add(new Column([], name)));
    }
  }

  /**
   * Generate a table from an iterable of rows.  Each element of the iterable is a Map.
   * The first element of the [rows] iterable is used to determine the column names.
   * Only the keys of a row that overlap with the keys from the first row
   * are added to the table.  Rows don't need to have keys in the same order.
   * This is different from the [rbind] method if the [strict]
   * argument is [true].
   */
  Table.from(Iterable rows, {bool strict: true}) {
    if (strict) {
      _colnames = rows.first.keys.toList();
    } else {
      // it's easiest to traverse twice -- unfortunately
      Set _names = new Set();
      rows.forEach((Map row) => _names = _names.union(row.keys.toSet()));
      _colnames = _names.toList();
    }
    _colnames.forEach((name) => _data.add(new Column([], name)));
    Map _ind = new Map.fromIterables(_colnames, new List.generate(_colnames.length, (i) => i));

    rows.forEach((Map row){
      _colnames.forEach((k) => _data[_ind[k]].data.add(row[k])); // will add null if not in row
    });
  }


  /**
   * Create a table by taking the Cartesian product of a list of Columns.
   * The columns can have different number of elements.
   */
  Table.fromCartesianProduct(List<Column> columns) {
    _colnames = columns.map((e) => e.name).toList();
    int N = columns.fold(1, (a,Column b) => a*b.data.length);
    // how many times I repeat each element of the columns
    List<int> nEach = columns.map((e) {
      N ~/= e.data.length;
      return N;
    }).toList();

    for (int j=0; j<ncol; j++) {
      Iterable block = columns[j].data.expand((e) => new List.generate(nEach[j], (i) => e));
      // how many times you repeat the block
      int nReps = columns.take(j).fold(1, (a,Column b) => a*b.data.length);
      List cj = [];
      new List.generate(nReps, (i) => block).forEach((e) => cj.addAll(e));
      _data.add(new Column(cj, columns[j].name));
    }
  }

  Iterator<Map> get iterator => new _TableIterator(this);

  /**
   * Add a column to this table.  When you add a new column to the table, the data you add
   * needs to match exactly the existing number of rows in the table.
   *
   * If the proposed column name already exists, the code throws.
   * If the name already exists, a new column name gets generated in the form 'V{number}'.
   *
   */
  void addColumn(List x, {String name}) {
    if (ncol > 0 && nrow != x.length)
      throw 'Cannot add column.  Number of rows does not match';
    if (name == null) name = _makeColumnName(ncol+1);
    else if (_colnames.contains(name)) {
      throw 'Column ${name} already exists, and strict = true';
    }
    _colnames.add(name);
    _data.add(new Column(x, name));
  }

  /**
   * Add a row of data to this table. The keys of the Map [x] need to be a superset of the
   * column names, but the order of the keys does not matter.  No checks are made if the
   * types of the new row match the existing data in the table.
   *
   * If the table is empty, all the keys in the Map [x] will be added to the table.
   *
   */
  void addRow(Map x) {
    if (nrow == 0) {
      // you add all the Map to the table
      x.forEach((k,v) {
        _colnames.add(k);
        _data.add(new Column([v], k));
      });
    } else {
      colnames.forEach((name){
        this[name].data.add(x[name]);
      });
    }
  }


  /**
   * Get the row i of the table as a Map.
   */
  Map row(int i) {
    Map res = {};
    for (int j=0; j<ncol; j++)
      res[_colnames[j]] = column(j).data[i];

    return res;
  }



  /**
   * Get column i.
   */
  Column column(int j) => _data[j];

  Column operator [](String columnName) => _data[_colnames.indexOf(columnName)];

  /**
   * Get the number of rows in the table.
   */
  int get nrow => (_data.isEmpty) ? 0 : _data.first.data.length;

  /**
   * Get the number of columns in the table.
   */
  int get ncol => (_colnames.isEmpty) ? 0 : _colnames.length;

  /**
   * Return the names of table columns as a List.
   */
  List<String> get colnames => _colnames;

  /**
   * Check if the table is empty.  You can have columns set up, but no data in them.
   */
  bool get isEmpty => (nrow == 0) ? true : false;

  /**
   * Change the name of column [i] to [name].
   * Throws if name is already taken.
   */
  void setColname(int j, String name) {
    if (_colnames.contains(name)) {
      throw 'Column ${name} already exists';
    }
    _colnames[j] = name;
  }


  /**
   * Apply function [f] to each column (possibly to a subset of columns specified by
   * [columnNames], by certain groups specified by [byColumnNames]),
   */
  Table columnApply(Function f, {List<String> variableNames}) {
    if (variableNames == null) variableNames = _colnames;

    Table res = new Table();
    for (String variable in variableNames) {
      var aux = f(this[variable]);
      res.addColumn([aux], name: variable);
    }

    return res;
  }

  /**
   * Get the distinct rows in the table.  You can restrict which columns you want
   * to show the distinct values.
   */
  Table distinct({List<String> columnNames}) {
    Set uRows = new LinkedHashSet(equals: _rowEquality.equals,
    isValidKey: _rowEquality.isValidKey,
    hashCode: (e) => _rowEquality.hash(e));
    if (columnNames == null) {
      for (int i=0; i<nrow; i++)
        uRows.add(row(i));
    } else {
      Map aux = {};
      for (int i=0; i<nrow; i++) {
        Map rowi = row(i);
        columnNames.forEach((name) => aux[name] = rowi[name]);
        uRows.add(aux);
      }
    }

    return new Table.from(uRows.toList());
  }

  /**
   * Make a copy of this table.
   */
  Table copy() {
    Table t = new Table();
    for (int j=0; j<ncol; j++)
      t.addColumn(new List.from(column(j).data), name: colnames[j]);

    return t;
  }

  /**
   * Column bind this table with another table.  Row numbers need to match.
   * If a column in the other table has the same name as a column in this table,
   * the column name gets prepended with '_Y'.
   */
  Table cbind(Table other) {
    if (nrow != other.nrow)
      throw 'Cannot cbind as tables don\'t have the same number of rows!';
    Set sNames = colnames.toSet();

    Table t = copy();
    for (int j=0; j<other.ncol; j++){
      String name = other.colnames[j];
      if (sNames.contains(name))
        name = '${name}_Y';
      t.addColumn(other.column(j).data, name: name);
    }

    return t;
  }

  /**
   * Row bind this table with another table.
   * If [strict] is true, the column names must match.  If [strict] is false,
   * new columns are created as needed.
   * Columns don't have to be in the same order, you can rbind [A,B] and [B,A].
   */
  Table rbind(Table other, {bool strict: true}) {
    if (strict && ncol != other.ncol)
      throw 'Cannot rbind because columns don\'t match and strict is true';

    // columns in other that are not in this table
    List<String> notInTable = new List.from(other.colnames);  // have problems when I remove!

    Table t = copy();
    for (int j=0; j<ncol; j++){
      String name = colnames[j];
      if (other.colnames.contains(name)) {
        // column exists in the other table
        t[name].data..addAll(new List.from(other[name].data));
        notInTable.remove(name);
      } else {
        // column does not exist in the other table
        // need to fill with nulls
        t[name].data..addAll(new List.filled(other.nrow, null));
      }
    }
    // there may be columns in other table that are not in this table
    for (String name in notInTable) {
      List x = new List.generate(nrow, (i) => null)..addAll(other[name].data);
      t.addColumn(x, name: name);
    }

    return t;
  }

  /**
   * Do an outer join of this table with table [other] by columns
   * that have the same name.
   *
   */
  Table joinTable(Table other, JOIN_TYPE type) {
    List<String> by = colnames.toSet().intersection(other.colnames.toSet()).toList();
    if (by.isEmpty)
      throw 'No common column names found between the two tables.';

    // split each table into groups of rows with same common by values
    var g1 = _groupBy(this, (e) => new Map.fromIterables(by,
    new List.generate(by.length, (i) => e[by[i]])));
    var g2 = _groupBy(other, (e) => new Map.fromIterables(by,
    new List.generate(by.length, (i) => e[by[i]])));
    Set g1k = new LinkedHashSet(equals: _rowEquality.equals,
    isValidKey: _rowEquality.isValidKey,
    hashCode: (e) => _rowEquality.hash(e));
    g1k.addAll(g1.keys);
    Set g2k = new LinkedHashSet(equals: _rowEquality.equals,
    isValidKey: _rowEquality.isValidKey,
    hashCode: (e) => _rowEquality.hash(e));
    g2k.addAll(g2.keys);

    List<Map> res = [];
    _addInnerRows() {
      // common keys
      Set gCommon = g1k.intersection(g2k);
      for (var group in gCommon) {
        for (Map v1 in g1[group]) {
          for (Map v2 in g2[group]) {
            Map e = new Map.from(v1);
            v2.forEach((k, v) {
              if (!by.contains(k)) e[k] = v;
            });
            res.add(e);
          }
        }
      }
    }
    _addLeftOnlyRows() {
      // filler for the missing columns in this other table; the columns in other that are not in by
      List rKeys = other.colnames.toSet().difference(by.toSet()).toList();
      Map rFill = new Map.fromIterables(rKeys, new List.filled(rKeys.length, null));

      // loop only over the keys that are missing in other table
      for (var group in g1k.difference(g2k)) {
        for (Map v1 in g1[group]) {
          // as the key is not there, add nulls for the missing variables in other
          res.add(new Map.from(v1)..addAll(rFill));
        }
      }
    }
    _addRightOnlyRows(){
      // filler for the missing columns in this table; the columns in this that are not in by
      List lKeys = colnames.toSet().difference(by.toSet()).toList();
      Map lFill = new Map.fromIterables(lKeys, new List.filled(lKeys.length, null));

      // loop only over the keys that are missing in this table
      for (var group in g2k.difference(g1k)) {
        for (Map v2 in g2[group]) {
          // if the key is not there, add nulls for the missing variables in this
          res.add(new Map.from(v2)..addAll(lFill));
        }
      }
    }

    switch (type) {
      case JOIN_TYPE.INNER_JOIN :
        _addInnerRows();
        break;
      case JOIN_TYPE.OUTER_JOIN :
        _addInnerRows();
        _addLeftOnlyRows();
        _addRightOnlyRows();
        break;
      case JOIN_TYPE.LEFT_JOIN :
        _addInnerRows();
        _addLeftOnlyRows();
        break;
      case JOIN_TYPE.RIGHT_JOIN :
        _addInnerRows();
        _addRightOnlyRows();
        break;
    }


    return new Table.from(res);
  }

  /**
   * Utility to group rows by a given function.
   */
  Map _groupBy(Iterable x, Function f) {
    Map result = new LinkedHashMap(equals: _rowEquality.equals,
    isValidKey: _rowEquality.isValidKey,
    hashCode: (e) => _rowEquality.hash(e));
    x.forEach((v) => result.putIfAbsent(f(v), () => []).add(v));

    return result;
  }

  /**
   * Utility to group rows by a given function.  Each value of the resulting Map
   * is a list of row indices.  It is a more memory efficient way to do the grouping.
   * Function [f] takes an element of the iterable and returns a grouping value.
   */
  Map _groupByIndex(Iterable x, Function f) {
    Map result = new LinkedHashMap(equals: _rowEquality.equals,
    isValidKey: _rowEquality.isValidKey,
    hashCode: (e) => _rowEquality.hash(e));

    int ind = 0;
    x.forEach((v) {
      result.putIfAbsent(f(v), () => []).add(ind);
      ind += 1;
    });

    return result;
  }

  /**
   * Apply function [f] to different groups of rows.  Rows are grouped
   * by the distinct values of the columns indicated by [groupBy].
   *
   */
  Table groupApply(Function f, List<String> groupBy, List<String> variables) {
    var by = groupBy.where((e) => colnames.contains(e)).toList();
    List vars = variables.where((e) => colnames.contains(e)).toList();
    Map _colIndex = new Map.fromIterables(colnames, new List.generate(colnames.length, (i) => i));

    Map groups = _groupByIndex(this, (e) => new Map.fromIterables(by,
    new List.generate(by.length, (i) => e[by[i]])));

    List res = [];
    groups.forEach((Map k, List ind) {
      Map row = new Map.from(k);
      vars.forEach((String variable) {
        var aux = ind.map((i) => _data[_colIndex[variable]].data[i]);
        row[variable] = f(aux);
      });
      res.add(row);
    });

    return new Table.from(res);
  }



  /**
   * Order the rows of the table with a natural order for some column names.
   * [orderBy] is a Map with the column name as the key and with the value either 1
   * (if the ordering is from lowest to highest) or -1 (if the ordering is to be done
   * from highest to lowest).
   *
   * For example, [orderBy = {'id': 1, 'code':-1}] will sort ascendingly on
   * column [id] and descendingly on column [code].
   *
   * Return a new table.
   */
  Table order(Map<String,int> orderBy) {
    List<String> keys = orderBy.keys.toList();
    if (colnames.first != keys.first)
      throw 'Column name ${keys.first} does not exist.';
    Ordering ord = new Ordering.natural().onResultOf((Map row) => row[keys.first]);
    if (orderBy[keys.first] == -1)
      ord = ord.reverse();
    keys.skip(1).forEach((String name) {
      if (!colnames.contains(name))
        throw 'Column name $name does not exist.';
      var aux = new Ordering.natural().onResultOf((Map row) => row[name]);
      if (orderBy[name] == -1)
        aux = aux.reverse();
      ord = ord.compound(aux);
    });

    return new Table.from(ord.sorted(this));
  }

  /**
   * Order the rows of the table according to a specific Ordering.
   *
   * Return a new table.
   */
  Table orderWith(Ordering ordering) => new Table.from(ordering.sorted(this));



  /**
   * A melt method similar to the R reshape package.
   * It reshapes the table into a long form, one row for all id variables and one
   * measurement variable with the value of the measured variable.
   * The [List<String> id] is the list of column names for the id variables.
   *
   * See http://had.co.nz/reshape/
   */
  Table melt(List<String> id) {
    Table t = new Table();
    List<String> variables = colnames.where((String name) => !id.contains(name)).toList();
    int N = nrow;
    Table idTable = new Table();
    id.forEach((String name) => idTable.addColumn(this[name].data, name: name));

    for (String variable in variables) {
      Table block = idTable.copy();
      block.addColumn(new List.filled(N, variable), name: 'variable');
      block.addColumn(this[variable].data, name: 'value');
      t = t.rbind(block, strict: false);
    }

    // remove the null values from the melted table
    return new Table.from(t.where((Map row) => row['value'] != null));
  }

  /**
   * Table must be in long form before cast is called.
   *
   */
  Table cast(List<String> vertical, List<String> horizontal, Function f,
             {String variable: 'value'}) {
    List _allGroups = new List.from(vertical)..addAll(horizontal);

    // group rows by
    Function _fg = (Map row) =>
    new Map.fromIterables(_allGroups, _allGroups.map((g) => row[g]));
    Map ind = _groupByIndex(this, _fg);
    int indValue = colnames.indexOf(variable);

    List res = [];
    ind.forEach((k,List v) {
      Map row = {};
      vertical.forEach((name) => row[name] = k[name]);

      List newName = [];
      horizontal.forEach((hName) => newName.add(k[hName]));
      row[newName.join('_')] = f(v.map((e) => _data[indValue].data[e]));
      res.add(row);
    });

    return new Table.from(res);
  }



  /**
   * Remove the column with name [columnName] from the table.  Returns true if the
   * [columnName] was a column name, false otherwise.
   */
  bool removeColumn(String columnName) {
    bool res = false;
    int ind = _colnames.indexOf(columnName);
    if (ind != -1) {
      _colnames.removeAt(ind);
      _data.removeAt(ind);
      res = true;
    }

    return res;
  }




  /**
   * Remove the row with index [i].  Return true if successful, false if not possible.
   */
  bool removeRow(int i) {
    bool res = true;
    if (i > nrow || i <0) {
      res = false;
    } else {
      for (int j=0; j<ncol; j++)
        column(j).data.removeAt(i);
    }

    return res;
  }


  String toString() {
    List<List<String>>out = new List.generate(nrow+1, (i) => new List.filled(ncol, ''));
    List<String> res = [];
    for (int j=0; j<ncol; j++) {
      var aux = column(j)._paddedOutput().toList();
      for (int i=0; i<nrow+1; i++)
        out[i][j] = aux[i];
    }
    for (int i=0; i<nrow+1; i++)
      res.add(out[i].join(' '));

    return res.join('\n');
  }


  /**
   * Return the first [n] rows of this table as another table.
   */
  Table head({int n: 6}) => new Table.from(this.take(n));

  /**
   * Sample [n] rows from this table and return it as another table.
   */
  Table sample({int n: 6}) {
    Random rand = new Random();
    List res = [];
    for (int i=0; i<n; i++) {
      res.add(row(rand.nextInt(nrow)));
    }
    return new Table.from(res);
  }

  /**
   * Make unique column name (in case there are collisions.)  The name is in the form
   * 'V{number}'.
   */
  String _makeColumnName(int n) {
    String proposed = 'V${n}';
    if (colnames.contains(proposed)) {
      proposed = _makeColumnName(n+1);
    }

    return proposed;
  }

}


class _TableIterator extends Iterator<Map>{
  Map _current;
  int ind;
  int nrow;
  Table _table;

  _TableIterator(Table this._table) {
    nrow = _table.nrow;
    ind = 0;
  }

  bool moveNext() {
    bool res = true;
    if (ind == nrow) {
      res = false;
    } else {
      _current = _table.row(ind);
      ind += 1;
    }

    return res;
  }
  Map get current => _current;
}



