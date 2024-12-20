library table_base;

import 'dart:collection';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:more/comparator.dart';
import 'package:csv/csv.dart';
import 'column.dart';

enum JoinType { outer, left, right, inner }

enum AlignType { first, last, center }

enum NullOrdering { first, last }

/// A tabular view of columnar data iterable by row.  A table holds observations
/// of different variables.  Each variable is stored in a [Column].
///
/// Data in columns is supposed to be of the same type, although this
/// is not enforced.
///
/// Conceptually, variables belong in two separate groups.
/// Categorical/classification/id variables and measurement variables.  For example,
/// a categorical variable may be an airport code, and a measurement variable
/// may be the daily max temperature at that location.
///
/// The null value is used to indicate missing data only.
///
/// Customize the digits display in the [toString] method with
/// [options['display']][['digits']] for doubles.
///
class Table extends Object with IterableMixin<Map?> {
  List<Column> _data = <Column>[];
  List<String> _colnames = <String>[];
  static const _rowEquality = MapEquality();
  static const _setEquality = SetEquality();
  static var _fillValue;

  /// Can control the formatting of double columns, for example give column
  /// with name 'A' you can specify
  /// {'format': 'A': (x) => (x as double).toStringAsPrecision(5)}
  /// Note that you can deal with [null] values directly in the [format]
  /// function, but if [nullToString] is not null, it overrides the
  /// specification in the format function.
  static final Map<String, dynamic> defaultOptions = <String, dynamic>{
    'columnSeparation': ' ',
    'format': <String, String Function(dynamic)>{},
    'columnWidth': <String, int>{},
    'fillValue':
        null, // what to replace nulls with.  Need to reconsider if this should be a column value not a table value!
    'nullToString': null, // how to treat nulls when printing
  };

  Map<String, dynamic>? _options;

  /// Construct an empty (0 rows) table with columns.
  Table({List<String>? colnames, Map<String, dynamic>? options}) {
    _data = <Column>[];
    _colnames = <String>[];
    if (colnames != null) {
      _colnames = colnames;
      for (var name in colnames) {
        _data.add(Column([], name));
      }
    }
    _options = defaultOptions;
    if (options != null) setOptions(options);
  }

  Map<String, dynamic> get options => _options ?? defaultOptions;

  /// Set the table options directly (overwriting the default options.)
  set options(Map<String, dynamic> xs) => _options = Map.from(xs);

  /// Modify the current options with the keys available in [xs].
  void setOptions(Map<String, dynamic> xs) {
    _options ??= defaultOptions;
    for (var key in xs.keys) {
      _options![key] = xs[key];
    }
  }

  /// Generate a table from an iterable of rows.  Each element of the iterable
  /// is a Map.  For example, this is a convenient way to initialize a table
  /// from json.
  ///
  /// The first element of the [rows] iterable is used to determine the column
  /// type.  Note: This can be problematic if the first row of the json input
  /// for a column contains an integer value and the following values are
  /// doubles.
  ///
  /// Only the keys of a row that overlap with the keys from the first row
  /// are added to the table.  Rows don't need to have keys in the same order.
  ///
  /// If [colnames] is not specified, the table column names
  /// will be determined by taking a set union of keys from each row.
  ///
  /// Missing data for a column will be assigned `null`.
  ///
  ///
  Table.from(Iterable<Map?> rows,
      {List<String>? colnames, Map<String, dynamic>? options}) {
    _options = {...defaultOptions};
    if (options != null) setOptions(options);

    if (colnames == null) {
      // it's easiest to traverse twice -- unfortunately
      var _names = <String>{};
      rows.forEach((Map? row) =>
          _names = _names.union(row!.keys.map((e) => e.toString()).toSet()));
      _colnames = _names.toList();
    } else {
      _colnames = [...colnames];
    }

    for (var name in _colnames) {
      var column = Column([], name);
      _data.add(column);
    }
    var _ind =
        Map.fromIterables(_colnames, List.generate(_colnames.length, (i) => i));

    if (_fillValue == null) {
      rows.forEach((Map? row) {
        _colnames.forEach((k) =>
            _data[_ind[k]!].data.add(row![k])); // will add null if not in row
      });
    } else {
      rows.forEach((Map? row) {
        _colnames.forEach((k) => row![k] == null
            ? _data[_ind[k]!].data.add(_fillValue)
            : _data[_ind[k]!].data.add(row[k]));
      });
    }
  }

  /// Create a table by taking the Cartesian product of a list of Columns.
  /// The columns can have different number of elements.
  Table.fromCartesianProduct(List<Column> columns) {
    _colnames = columns.map((e) => e.name).toList();
    var N =
        columns.fold(1, (dynamic a, Column b) => (a as int) * b.data.length);
    // how many times I repeat each element of the columns
    var nEach = columns.map((e) {
      N ~/= e.data.length;
      return N;
    }).toList();

    for (var j = 0; j < _colnames.length; j++) {
      var block =
          columns[j].data.expand((e) => List.generate(nEach[j], (i) => e));
      // how many times you repeat the block
      var nReps =
          columns.take(j).fold(1, (dynamic a, Column b) => a * b.data.length);
      var cj = [];
      List.generate(nReps, (i) => block).forEach((e) => cj.addAll(e));
      _data.add(Column(cj, columns[j].name));
    }
  }

  @override
  Iterator<Map?> get iterator => _TableIterator(this);

  /// Add a column to this table.  When you add a new column to the table, the data you add
  /// needs to match exactly the existing number of rows in the table.
  ///
  /// If the proposed column name already exists, the code throws.
  /// If the name already exists, a new column name gets generated in the form 'V{number}'.
  ///
  void addColumn(List x, {String? name}) {
    if (ncol > 0 && nrow != x.length) {
      throw ArgumentError('Cannot add column.  Number of rows does not match');
    }
    if (name == null) {
      name = _makeColumnName(ncol + 1);
    } else if (_colnames.contains(name)) {
      throw ArgumentError('Column $name already exists, and strict = true');
    }
    _colnames.add(name);
    _data.add(Column(x, name));
  }

  /// Add a row of data to this table. The keys of the Map [x] need to be a superset of the
  /// column names, but the order of the keys does not matter.  No checks are made if the
  /// types of the new row match the existing data in the table.
  ///
  /// If the table is empty, all the keys in the Map [x] will be added to the table.
  ///
  void addRow(Map x) {
    if (nrow == 0) {
      // you add all the Map to the table
      x.forEach((k, v) {
        _colnames.add(k);
        _data.add(Column([v], k));
      });
    } else {
      colnames.forEach((name) {
        this[name].data.add(x[name]);
      });
    }
  }

  /// Get the row i of the table as a Map.
  Map row(int? i) {
    var res = {};
    for (var j = 0; j < ncol; j++) {
      res[_colnames[j]] = column(j).data[i!];
    }

    return res;
  }

  /// Get column i.
  Column column(int j) => _data[j];

  Column operator [](String columnName) => _data[_colnames.indexOf(columnName)];

  /// Get the number of rows in the table.
  int get nrow => (_data.isEmpty) ? 0 : _data.first.data.length;

  /// Get the number of columns in the table.
  int get ncol => (_data.isEmpty) ? 0 : _data.length;

  /// Return the names of table columns as a List.
  List<String> get colnames => _colnames;

  /// Check if the table is empty.  You can have columns set up, but no data in them.
  @override
  bool get isEmpty => (nrow == 0) ? true : false;

  /// Change the name of column [i] to [name].
  /// Throws if name is already taken.
  void setColname(int j, String name) {
    if (_colnames.contains(name)) {
      throw 'Column $name already exists';
    }
    _colnames[j] = name;
  }

  /// Apply function [f] to each column (or possibly to a subset of columns
  /// as specified by [columnNames]).
  Table columnApply(Function f, {List<String>? variableNames}) {
    variableNames ??= _colnames;

    var res = Table();
    for (var variable in variableNames) {
      var aux = f(this[variable]);
      res.addColumn([aux], name: variable);
    }

    return res;
  }

  /// Get the distinct rows in the table.
  ///
  /// You can restrict which columns you want to show the distinct values
  /// by specifying the [columnNames] list.
  Table distinct({List<String>? columnNames}) {
    var uRows = LinkedHashSet(
        equals: _rowEquality.equals,
        isValidKey: _rowEquality.isValidKey,
        hashCode: (dynamic e) => _rowEquality.hash(e));
    if (columnNames == null) {
      for (var i = 0; i < nrow; i++) {
        uRows.add(row(i));
      }
    } else {
      var aux = {};
      for (var i = 0; i < nrow; i++) {
        var rowi = row(i);
        columnNames.forEach((name) => aux[name] = rowi[name]);
        uRows.add(aux);
      }
    }

    return Table.from(uRows.toList());
  }

  /// Make a copy of this table.
  ///
  /// If [colnames] is not specified, it copies the existing table.
  ///
  /// If [colnames] are specified, create a new table with a subset of the
  /// existing columns.
  ///
  Table copy({List<String>? colnames}) {
    colnames ??= _colnames;

    var t = Table();
    for (var j = 0; j < colnames.length; j++) {
      var idx = _colnames.indexOf(colnames[j]);
      t.addColumn(List.from(column(idx).data), name: colnames[j]);
    }
    return t;
  }

  /// Column bind this table with another table.  Row numbers need to match.
  /// If a column in the other table has the same name as a column in this table,
  /// the column name gets prepended with '_Y'.
  Table cbind(Table other) {
    if (nrow != other.nrow) {
      throw 'Cannot cbind as tables don\'t have the same number of rows!';
    }
    Set sNames = colnames.toSet();

    var t = copy();
    for (var j = 0; j < other.ncol; j++) {
      var name = other.colnames[j];
      if (sNames.contains(name)) name = '${name}_Y';
      t.addColumn(other.column(j).data, name: name);
    }

    return t;
  }

  /// Row bind this table with another table.  It adds the observations from [other]
  /// after the observations of this table.
  ///
  /// If [strict] is `true`, the column names must match exactly.
  ///
  /// If [strict] is `false`, new columns are created as needed and filled with `null`s.
  ///
  /// The columns of the [other] table don't have to be in the same order as the columns
  /// of this table.
  Table rbind(Table other, {bool strict = true}) {
    if (strict &&
        !_setEquality.equals(colnames.toSet(), other.colnames.toSet())) {
      throw 'Cannot rbind because columns don\'t match and strict is true';
    }

    // columns in other that are not in this table
    var notInTable = other.colnames.toSet();

    var t = copy();
    for (var j = 0; j < ncol; j++) {
      var name = colnames[j];
      if (other.colnames.contains(name)) {
        // column exists in the other table
        t[name].data.addAll(List.from(other[name].data));
        notInTable.remove(name);
      } else {
        // column does not exist in the other table
        // need to fill with nulls
        t[name].data.addAll(List.filled(other.nrow, null));
      }
    }
    // there may be columns in other table that are not in this table
    for (var name in notInTable) {
      var x = List<dynamic>.generate(nrow, (i) => null)
        ..addAll(other[name].data);
      t.addColumn(x, name: name);
    }

    return t;
  }

  /// Do an outer join of this table with table [other] by columns
  /// that have the same name.
  ///
  Table joinTable(Table other, JoinType type) {
    var by = colnames.toSet().intersection(other.colnames.toSet()).toList();
    if (by.isEmpty) {
      throw 'No common column names found between the two tables.';
    }

    // split each table into groups of rows with same common by values
    var g1 = _groupBy(
        this,
        (e) =>
            Map.fromIterables(by, List.generate(by.length, (i) => e[by[i]])));
    var g2 = _groupBy(
        other,
        (e) =>
            Map.fromIterables(by, List.generate(by.length, (i) => e[by[i]])));
    Set g1k = LinkedHashSet(
        equals: _rowEquality.equals as bool Function(dynamic, dynamic)?,
        isValidKey: _rowEquality.isValidKey,
        hashCode: (e) => _rowEquality.hash(e));
    g1k.addAll(g1.keys);
    Set g2k = LinkedHashSet(
        equals: _rowEquality.equals as bool Function(dynamic, dynamic)?,
        isValidKey: _rowEquality.isValidKey,
        hashCode: (e) => _rowEquality.hash(e));
    g2k.addAll(g2.keys);

    var res = <Map>[];
    void _addInnerRows() {
      // common keys
      var gCommon = g1k.intersection(g2k);
      for (var group in gCommon) {
        for (Map v1 in g1[group]) {
          for (Map v2 in g2[group]) {
            var e = Map.from(v1);
            v2.forEach((k, v) {
              if (!by.contains(k)) e[k] = v;
            });
            res.add(e);
          }
        }
      }
    }

    void _addLeftOnlyRows() {
      // filler for the missing columns in this other table; the columns in other that are not in by
      List rKeys = other.colnames.toSet().difference(by.toSet()).toList();
      var rFill =
          Map.fromIterables(rKeys, List<dynamic>.filled(rKeys.length, null));

      // loop only over the keys that are missing in other table
      for (var group in g1k.difference(g2k)) {
        for (Map v1 in g1[group]) {
          // as the key is not there, add nulls for the missing variables in other
          res.add(Map.from(v1)..addAll(rFill));
        }
      }
    }

    void _addRightOnlyRows() {
      // filler for the missing columns in this table; the columns in this that are not in by
      List lKeys = colnames.toSet().difference(by.toSet()).toList();
      var lFill =
          Map.fromIterables(lKeys, List<dynamic>.filled(lKeys.length, null));

      // loop only over the keys that are missing in this table
      for (var group in g2k.difference(g1k)) {
        for (Map v2 in g2[group]) {
          // if the key is not there, add nulls for the missing variables in this
          res.add(Map.from(v2)..addAll(lFill));
        }
      }
    }

    switch (type) {
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

    return Table.from(res);
  }

  /// Utility to group rows by a given function.
  Map _groupBy(Iterable x, Function f) {
    var result = LinkedHashMap(
        equals: _rowEquality.equals,
        isValidKey: _rowEquality.isValidKey,
        hashCode: (dynamic e) => _rowEquality.hash(e));
    x.forEach((v) => result.putIfAbsent(f(v), () => []).add(v));

    return result;
  }

  /// Utility to group rows by a given function.
  /// Each key of the resulting Map is the grouping value.
  /// Each value of the resulting Map is a list of row indices.
  ///
  /// It is a more memory efficient way to do the grouping.
  /// Function [f] takes an element of the iterable and returns a grouping value.
  /// In this case the Iterable x is the actual table.
  Map<dynamic, List<int>> _groupByIndex(Iterable x, Function f) {
    Map<dynamic, List<int>> result = LinkedHashMap(
        equals: _rowEquality.equals as bool Function(dynamic, dynamic)?,
        isValidKey: _rowEquality.isValidKey,
        hashCode: (e) => _rowEquality.hash(e));

    var ind = 0;
    x.forEach((row) {
      result.putIfAbsent(f(row), () => []).add(ind);
      ind += 1;
    });

    return result;
  }

  /// Apply function [f] to different groups of rows.  Rows are grouped
  /// by the distinct values of the columns indicated by [groupBy].
  /// If [groupBy] is not specified, the function [f] is applied to
  /// each individual row.
  ///
  /// Function [f] takes an [Iterable] and returns a Map with String keys.
  /// The Map returned by [f] will be used to construct the [Table] returned.
  ///
  /// For example to calculate the sum by the [groupBy] variables,
  /// ```
  /// Function f = (Iterable<num> x) => x.reduce((a,b) => {'sum': a+b});
  /// ```
  Table groupApply(dynamic Function(Iterable<dynamic> x) f,
      {List<String>? groupBy, required List<String> variables}) {
    var res = <Map>[];

    if (groupBy == null) {
      forEach((row) {
        res.add(f([row]));
      });
    } else {
      var by = groupBy.where((e) => colnames.contains(e)).toList();
      var vars = variables.where((e) => colnames.contains(e)).toList();
      var _colIndex =
          Map.fromIterables(colnames, List.generate(colnames.length, (i) => i));

      var groups = _groupByIndex(
          this,
          (e) =>
              Map.fromIterables(by, List.generate(by.length, (i) => e[by[i]])));

      groups.forEach((k, List ind) {
        var row = Map.from(k as Map);
        vars.forEach((String variable) {
          var aux = ind.map((i) => _data[_colIndex[variable]!].data[i]);
          row[variable] = f(aux);
        });
        res.add(row);
      });
    }

    return Table.from(res);
  }

//  /**
//   * Apply function [f] to different groups of rows.  Rows are grouped
//   * by the distinct values of the columns indicated by [groupBy].
//   *
//   * In many usual cases only a simple aggregation of variables is needed.
//   * The list of variables to aggregate will not be `null`.
//   * The function [f] takes an Iterable corresponding to the values
//   * of one variable for this grouping, and returns a single value.
//   * For example to calculate the sum by the [groupBy] variables,
//   * ```
//   * Function f = (Iterable<num> x) => x.reduce((a,b) => a+b);
//   * ```
//   *
//   * If during your aggregation, the function [f] needs to
//   * access more than one variable, leave the [variables]
//   * argument `null`.  The function [f] will then take the full row
//   * as a `Map` input.  For example if a table has 3 columns
//   * (Id, Min, Max) and you want to calculate the average range by Id
//   * ```
//   * Function f = (Map )
//   * ```
//   *
//   *
//   * If the function [f] returns multiple values
//   *
//   */
//  Table groupApply2(List<String> groupBy, Function f, {List<String> variables, bool unwind: false}) {
//    var by = groupBy.where((e) => colnames.contains(e)).toList();
//    List vars = variables.where((e) => colnames.contains(e)).toList();
//    Map _colIndex = new Map.fromIterables(
//        colnames, new List.generate(colnames.length, (i) => i));
//
//    Map groups = _groupByIndex(
//        this,
//            (e) => new Map.fromIterables(
//            by, new List.generate(by.length, (i) => e[by[i]])));
//
//    List res = [];
//    groups.forEach((Map k, List ind) {
//      Map row = new Map.from(k);
//      vars.forEach((String variable) {
//        var aux = ind.map((i) => _data[_colIndex[variable]].data[i]);
//        row[variable] = f(aux);
//      });
//      res.add(row);
//    });
//
//    return new Table.from(res);
//  }

  /// Apply function [f] on a list of [variables] to [width] observations
  /// at a time.
  ///
  /// For example, this method is convenient to calculate moving averages
  /// if the observations of the table are ordered by time.
  ///
  ///
  List rollApply(String variable, int width, Function f,
      {AlignType align = AlignType.last}) {
    if (width % 2 == 0 && align == AlignType.center) {
      throw 'ALIGN_TYPE.CENTER does not work for an even width.';
    }

    var iEnd = width;
    var res = [];
    if (align == AlignType.last) {
      res.addAll(List.filled(width - 1, null));
    } else if (align == AlignType.center) {
      res.addAll(List.filled(width ~/ 2, null));
    }

    while (iEnd <= nrow) {
      res.add(f(this[variable].data.sublist(iEnd - width, iEnd)));
      iEnd += 1;
    }

    if (align == AlignType.first) {
      res.addAll(List.filled(width - 1, null));
    } else if (align == AlignType.center) {
      res.addAll(List.filled(width ~/ 2, null));
    }

    return res;
  }

  /// Order the rows of the table according to a specific Comparator.
  /// Return a new table.
  ///
  /// See the examples from [sort_test] on how to construct a [Comparator].
  Table orderWith(Comparator ordering) =>
      Table.from(ordering.sorted(this) as List<Map>);

  /// A melt method similar to the R reshape package.
  /// It reshapes the table into a long form, one row for all id variables and one
  /// measurement variable with the value of the measured variable.
  /// The [List<String> id] is the list of column names for the id variables.
  ///
  /// See http://had.co.nz/reshape/
  Table melt(List<String> id) {
    var t = Table();
    var variables =
        colnames.where((String name) => !id.contains(name)).toList();
    var N = nrow;
    var idTable = Table();
    id.forEach((String name) => idTable.addColumn(this[name].data, name: name));

    for (var variable in variables) {
      var block = idTable.copy();
      block.addColumn(List.filled(N, variable), name: 'variable');
      block.addColumn(this[variable].data, name: 'value');
      t = t.rbind(block, strict: false);
    }

    // remove the null values from the melted table
    return Table.from(t.where((Map? row) => row!['value'] != null));
  }

  /// Reshape (pivot) a table (with a summary function).  The [vertical] list indicates the
  /// variables that will remain along the rows.  The variables in the [horizontal]
  /// list will be transposed and the unique values will become columns.
  ///
  /// The summary function [f] takes an `Iterable` and returns a value.
  ///
  /// For example, to pivot this 4 rows and 3 columns table
  /// ```
  /// [{'code': 'BOS', 'month': 'Jan', 'value': 10},
  /// {'code': 'BOS', 'month': 'Feb', 'value': 20},
  /// {'code': 'BOS', 'month': 'Mar', 'value': 30},
  /// {'code': 'LAX', 'month': 'Jan', 'value': 40}]
  /// ```
  /// by calling `cast(['code'], ['month'], (x) => x.first)`
  /// you get a table with 2 rows and 4 columns
  /// ```
  /// [{'code': 'BOS', 'Jan': 10, 'Feb': 20, 'Mar': 30},
  ///  {'code': 'LAX', 'Jan': 40, 'Feb': null, 'Mar': null}].
  ///```
  /// Missing values are filled with `null`s by default, unless specified by
  /// the `fill` argument.
  Table reshape(List<String> vertical, List<String> horizontal, Function f,
      {String variable = 'value', dynamic fill}) {
    var grp = List<String>.from(vertical)..addAll(horizontal);

    /// collapse into unique groups first
    var tbl = groupApply(f as dynamic Function(Iterable<dynamic>),
        groupBy: grp, variables: [variable]);

    /// and now pivot it
    return tbl._pivot(vertical, horizontal, variable: variable, fill: fill);
  }

  /// Just pivot the table, no aggregation done.
  Table _pivot(List<String> vertical, List<String> horizontal,
      {String variable = 'value', dynamic fill}) {
    // group rows
    Function _fg =
        (Map row) => Map.fromIterables(vertical, vertical.map((g) => row[g]));
    var ind = _groupByIndex(this, _fg);
    var indValue = colnames.indexOf(variable);

    // the horizontal columns may need to be joined
    var horizontalVals = <String>[];
    if (horizontal.length == 1) {
      horizontalVals =
          this[horizontal.first].data.map((e) => e.toString()).toList();
    } else {
      forEach((row) {
        var str = horizontal.map((name) => row![name]).join('_');
        horizontalVals.add(str);
      });
    }

    var res = <Map>[];
    ind.forEach((k, List v) {
      var row = {};
      vertical.forEach((name) => row[name] = k[name]);

      v.forEach((i) => row[horizontalVals[i]] = column(indValue)[i]);
      res.add(row);
    });

    if (fill != null) _fillValue = fill;
    var t = Table.from(res);

    if (fill != null) _fillValue = null; // restore the default
    return t;
  }

  /// Remove the column with name [columnName] from the table.  Returns true
  /// if the [columnName] was a column name, false otherwise.
  bool removeColumn(String columnName) {
    var res = false;
    var ind = _colnames.indexOf(columnName);
    if (ind != -1) {
      _colnames.removeAt(ind);
      _data.removeAt(ind);
      res = true;
    }

    return res;
  }

  /// Remove the row with index [i].  Return true if successful, false if not.
  bool removeRow(int i) {
    var res = true;
    if (i > nrow || i < 0) {
      res = false;
    } else {
      for (var j = 0; j < ncol; j++) {
        column(j).data.removeAt(i);
      }
    }
    return res;
  }

  /// Reorder columns (useful for printing.)  For example if columns are
  /// ['C', 'A', 'B'], reorder them to ['A', 'B', 'C'].
  ///
  void reorderColumns(List<String> newColumnNames) {
    if (newColumnNames.length != colnames.length) {
      throw StateError('Column names should have the same length.');
    }
    for (var i = 0; i < newColumnNames.length; i++) {
      var idx = _colnames.indexOf(newColumnNames[i]);
      _colnames.insert(i, newColumnNames[i]);
      _data.insert(i, _data[idx]);
    }
    _colnames = _colnames.sublist(0, newColumnNames.length);
    _data = _data.sublist(0, newColumnNames.length);
  }

  /// Output the table as a CSV string.
  String toCsv() {
    var nullToString = options['nullToString'] ?? '';
    var rows = List.generate(nrow + 1, (i) => []);
    rows[0] = List.from(colnames);
    for (var j = 0; j < ncol; j++) {
      var cj = column(j);
      for (var i = 0; i < nrow; i++) {
        if (cj[i] == null) {
          rows[i + 1].add(nullToString);
        } else {
          rows[i + 1].add(cj[i]);
        }
      }
    }
    return const ListToCsvConverter().convert(rows);
  }

  /// Column aligned toString output convenient for printing on screen.
  @override
  String toString() {
    var out = List.generate(nrow + 1, (i) => List.filled(ncol, ''));
    var res = <String>[];
    for (var j = 0; j < ncol; j++) {
      var columnWidth = options['columnWidth'][column(j).name] as int?;
      var columnFormat =
          options['format'][column(j).name] as String Function(dynamic)?;
      var aux = column(j)
          .paddedOutput(
              width: columnWidth,
              format: columnFormat,
              nullToString: options['nullToString'])
          .toList();

      for (var i = 0; i < nrow + 1; i++) {
        out[i][j] = aux[i];
      }
    }
    for (var i = 0; i < nrow + 1; i++) {
      res.add(out[i].join(options['columnSeparation']));
    }
    return res.join('\n');
  }

  /// Create an Html table.
  ///
  /// Support a subset of features:
  /// * a class name to allow styling via an external CSS file.
  /// * a caption for the table.
  /// * additional header rows before the actual data.  This can be useful to
  ///   show grouping of columns.
  ///
  /// See the tests for some examples.
  ///
  String toHtml({
    String? className,
    String? caption,
    List<String>? extraHeaders,
    bool includeColumnNames = true,
  }) {
    var nullToString = options['nullToString'] ?? '';
    var out = StringBuffer();
    if (className == null) {
      out.writeln('<table>');
    } else {
      out.writeln('<table class="$className">');
    }
    // add caption
    if (caption != null) {
      out.writeln('<caption>$caption</caption>');
    }
    out.writeln('<thead>');
    // add additional headers
    if (extraHeaders != null) {
      for (var e in extraHeaders) {
        out.writeln(e);
      }
    }
    // add headers from column names
    if (includeColumnNames) {
      out.writeAll([
        '<tr>',
        ...[for (var e in colnames) '<th>$e</th>'],
        '</tr>\n',
      ]);
    }
    out.writeln('</thead>');
    // add rows with table content
    out.writeln('<tbody>');
    for (var r = 0; r < nrow; r++) {
      out.write('<tr>');
      for (var c = 0; c < ncol; c++) {
        var columnFormat =
            options['format'][column(c).name] as String Function(dynamic)?;
        var value = (columnFormat != null)
            ? columnFormat(column(c)[r])
            : (column(c)[r] ?? nullToString);
        out.write('<td>${value}</td>');
      }
      out.write('</tr>\n');
    }
    out.writeln('</tbody>');
    out.writeln('</table>');
    return out.toString();
  }

  /// Return the first [n] rows of this table as another table.
  Table head({int n = 6}) => Table.from(take(n));

  /// Sample [n] rows from this table and return it as another table.
  Table sample({int n = 6}) {
    var rand = Random();
    var res = <Map>[];
    for (var i = 0; i < n; i++) {
      res.add(row(rand.nextInt(nrow)));
    }
    return Table.from(res);
  }

  /// Make unique column name (in case there are collisions.)  The name is
  /// in the form 'V{number}'.
  String _makeColumnName(int n) {
    var proposed = 'V$n';
    if (colnames.contains(proposed)) {
      proposed = _makeColumnName(n + 1);
    }
    return proposed;
  }
}

class _TableIterator implements Iterator<Map?> {
  Map? _current;
  int? ind;
  int? nrow;
  final Table _table;

  _TableIterator(this._table) {
    nrow = _table.nrow;
    ind = 0;
  }

  @override
  bool moveNext() {
    var res = true;
    if (ind == nrow) {
      res = false;
    } else {
      _current = _table.row(ind);
      ind = ind! + 1;
    }

    return res;
  }

  @override
  Map? get current => _current;
}
