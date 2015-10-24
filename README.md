# table

A table-like data structure for Dart.  It allows for convenient
split-apply-combine workflows typically used in data analysis.

This package borrows ideas from `R`'s `data.frame` and the
[reshape](http://had.co.nz/reshape/) package.

## NOTE

This code is very experimental.  I have no ideas yet how well things work, how
natural the code feels, how fast table manipulations are, etc.  In any case, as all
the operations are done in memory, this package is best suited for small to
medium size problems (let's just say small if you are from Texas.)  The goal of this
package is *convenience* not speed or a small memory footprint.

Also, the API may change savagely from one minor version to another.  When things
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

#### Joins
Tables can be joined in the SQL sense on columns that have the same name.  For example, 
given the two tables 
```dart
Table t1 = new Table.from([
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BWI', 'Tmin': 32},
        {'code': 'LAX', 'Tmin': 49}
      ]);
Table t2 = new Table.from([
        {'code': 'BOS', 'Tmax': 95},
        {'code': 'ORH', 'Tmax': 92},
        {'code': 'LAX', 'Tmax': 82}
      ]);
```
you can do an inner join by the variable `code` like this
```dart
Table tbl = t1.joinTable(t2, JOIN_TYPE.INNER_JOIN);
```
to get 
| code  | Tmin   | Tmax  |
| ----- | ------ | ----- |
| BOS   |  30    | 95    |
| LAX   |  49    | 82    |

#### Group apply

You can split the table into groups according to several variables and then 
apply a function to a variable from each individual groups.  For example, given 
the table
```dart
Table t = new Table.from([
        {'farm': 'A', 'checked': true, 'meatType': 'poultry', 'quantity': 10},
        {'farm': 'A', 'checked': true, 'meatType': 'pork', 'quantity': 20},
        {'farm': 'A', 'checked': false, 'meatType': 'beef', 'quantity': 30},
        {'farm': 'B', 'checked': true, 'meatType': 'poultry', 'quantity': 15},
        {'farm': 'B', 'checked': false, 'meatType': 'pork', 'quantity': 25},
        {'farm': 'B', 'checked': true, 'meatType': 'beef', 'quantity': 35}
]);
Function sum = (Iterable<num> x) => x.reduce((a,b) => a+b);
Table gT = t.groupApply(['farm', 'checked'], ['quantity'], sum);
```
you calculate the total quantity by `farm` and `checked` variable to get
| farm | checked | quantity |
| ---- | ------- | -------- |
| A    | true    | 30       |
| A    | false   | 30       |
| B    | true    | 50       |
| B    |false    | 25       |

The `groupApply` method is the equivalent of the SQL group by statement.

 
#### Reshape (melt and cast) 
As in the `R`'s [reshape](http://had.co.nz/reshape/) package, there are 
two methods `melt` and `cast` to allow for reshaping the table. 




## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/thumbert/table/issues

