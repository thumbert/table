# table

A table-like data structure for Dart.  It allows for convenient
split-apply-combine workflows typically used in data analysis.

This package borrows ideas from `R`'s `data.frame` and the
[reshape](http://had.co.nz/reshape/) package.

## NOTE

This code is very experimental.  I have no ideas yet how well things work, how
natural the code feels, how fast table manipulations are, etc.  In any case, as all
the operations are done in memory, this package is best suited for small to
medium size problems (let\'s just say small if you are from Texas.)  The goal of this
package is *convenience* not speed or a small memory footprint.

Also, the API will change savagely from one minor version to another.  When things
stabilize this message will disappear.


## Usage

### Terminology

A table is composed of variables arranged in columns.  I will interchangeably
use the terms column and variable.  Each row of a table is said to form an observation
also referred to as a record.  Conceptually, variables can be categorical/grouping/id
variables or measurement variables.  Missing variable values are encoded with
`null`s.  (No, `null` is not his last name,  somehow the value of his last name
did not get recorded.)

### Examples
Create a table with two columns
```dart
Table t = new Table()
  ..addColumn(['BWI', 'BWI', 'BOS'], name: 'code')
  ..addColumn([31, 30, 33], name: 'Tmin');
```
The table has `t.nrow` rows and `t.ncol` columns.  The columns have names `t.colnames`.

You can add additional rows of data with `t.addRow({'code': 'LAX', 'Tmin': 45})`.

A table can also be created directly from an iterable of rows
```dart
Table t1 = new Table.from([
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BWI', 'Tmin': 32},
        {'code': 'LAX', 'Tmin': 49}
      ]);
```

You can extract the column of a table by direct subset of the table `t['code']`.

`Table` extends `IterableMixin` so for example you can filter rows as any other iterable
 ```t.where((Map row) => row['Tmin'] > 33)```

Often it is useful to find the distinct values of a few columns (variables).
`t.distinct(variables: ['code'])` for example to return the distinct values of the
code variable.

Sort the rows of the table with
```dart
t.order({'code': 1, 'Tmin': -1})
```
where column `code` is sorted ascendingly and column `Tmin` is sorted descendingly.

You can column bind `cbind` two tables with the same number of rows.  You can
row bind `rbind` two tables with the same column names.

Tables can be joined in the SQL sense on columns that have the same name.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/thumbert/table/issues

