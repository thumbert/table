# table

A table like data structure for Dart.  It allows for convenient
split-apply-combine workflows typically used in data analysis.

This package borrows ideas from `R`'s `data.frames` and the
[reshape](http://had.co.nz/reshape/) package.

*NOTE* The code is very experimental and my first attempt at a public Dart
software.  Proceed with caution.   

## Usage

Create a table with two columns
```dart
Table t = new Table()
  ..addColumn(['BWI', 'BWI', 'BOS'], name: 'code')
  ..addColumn([31, 30, 33], name: 'Tmin');
```
## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/thumbert/table/issues

