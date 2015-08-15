# table

A table like data structure for Dart.  It allows for convenient
split-apply-combine workflows typically used in data analysis.

This package borrows ideas from `R`'s `data.frames` and the
[reshape](http://had.co.nz/reshape/) package.

**NOTE:**  This code is very experimental and it is my first attempt
at public Dart software.  Proceed with caution.

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
The table has `t.nrow` rows (3) and `t.ncol` columns (2).
The columns have names `t.colnames` (`['code', 'Tmin']`).

You can add additional rows of data with `t.addRow({'code': 'LAX', 'Tmin': 45})`.

A table can also be created directly from an iterable of rows
```dart
Table t1 = new Table.from([
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BWI', 'Tmin': 32},
        {'code': 'LAX', 'Tmin': 49}
      ]);
```

You can extract the column of a table by direct subset `t['code']`.

`Table` extends `IterableMixin` so for example you can filter rows as any other iterable
 `t.where((Map row) => row['Tmin'] > 33)`.

Often it is useful to know the distinct values of a few columns (variables).
`t.distinct(variables: ['code'])` for example to return the distinct values of the
code variable.


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/thumbert/table/issues

