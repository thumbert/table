// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library table.test;

import 'package:test/test.dart';
import 'package:table/table.dart';

column_test() {
  test('print column', () {
    Column c = new Column(['BWI', 'BOS', 'DC'], 'airport');
    expect(c.toString(), 'airport\n    BWI\n    BOS\n     DC');
  });
}

table_simple() {
  group('table: ', () {
    test('construct an empty table', () {
      Table t = new Table();
      expect(t.nrow, 0);
      expect(t.ncol, 0);
    });

    test('construct an empty table with column names', () {
      Table t = new Table(colnames: ['code', 'Tmin']);
      expect(t.nrow, 0);
      expect(t.ncol, 2);
    });

    test('construct table with one column', () {
      Table t = new Table()..addColumn([1, 2, 3], name: 'int');
      expect(t.nrow, 3);
      expect(t.ncol, 1);
    });

    test('construct table with two columns', () {
      Table t = new Table()
        ..addColumn(['BWI', 'BWI', 'BOS'], name: 'code')
        ..addColumn([1, 2, 3], name: 'value');
      expect(t.nrow, 3);
      expect(t.ncol, 2);
      expect(t.colnames, ['code', 'value']);
      expect(t['value'].toList(), [1, 2, 3]);
      expect(t.column(0).toList(), ['BWI', 'BWI', 'BOS']);
      expect(t.row(1), {'code': 'BWI', 'value': 2});
    });

    test('construct table from row iterator', () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'code': 'BOS', 'value': 4}
      ];
      Table t = new Table.from(rows);
      expect(t.nrow, 2);
      expect(t.ncol, 2);
      expect(t.colnames, ['code', 'value']);
    });

    test('construct table from row iterator (map elements not in same order)',
        () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'value': 4, 'code': 'BOS'}
      ];
      Table t = new Table.from(rows);
      expect(t.nrow, 2);
      expect(t.ncol, 2);
      expect(t.colnames, ['code', 'value']);
      expect(t['value'].data, [2, 4]);
    });

    test('construct table from row iterator (non-strict)', () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'Tmin': 24, 'code': 'BOS'}
      ];
      Table t = new Table.from(rows, colnamesFromFirstRow: false);
      expect(t.nrow, 2);
      expect(t.ncol, 3);
      expect(t.colnames, ['code', 'value', 'Tmin']);
      expect(t['value'].data, [2, null]);
      expect(t['Tmin'].data, [null, 24]);
    });

    test('construct table from cartesian product', () {
      Table t = new Table.fromCartesianProduct([
        new Column(['BWI', 'BOS', 'LAX'], 'code'),
        new Column(['Tmin', 'Tmax'], 'variable'),
        new Column(['A', 'B'], 'equipment')
      ]);
      expect(t.nrow, 12);
      expect(t['equipment'].data,
          ['A', 'B', 'A', 'B', 'A', 'B', 'A', 'B', 'A', 'B', 'A', 'B']);
      //print(t);
    });

    test('row iterator', () {
      Table t = new Table()
        ..addColumn(['BWI', 'BWI', 'BOS'], name: 'code')
        ..addColumn([1, 2, 3], name: 'value');
      Iterator it = t.iterator;
      expect(it.current, null);
      it.moveNext();
      expect(it.current, {'code': 'BWI', 'value': 1});
    });

    test('row filtering with where', () {
      Table t = new Table()
        ..addColumn(['BWI', 'BOS', 'BWI', 'BOS'], name: 'code')
        ..addColumn([1, 2, 3, 4], name: 'value');
      expect(t.where((e) => e['code'] == 'BOS').toList(), [
        {'code': 'BOS', 'value': 2},
        {'code': 'BOS', 'value': 4}
      ]);
      //print(t.elementAt(0));
    });

    test('unique rows of a table', () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'code': 'BWI', 'value': 10},
        {'code': 'BOS', 'value': 2},
        {'code': 'BWI', 'value': 100},
      ];
      Table t = new Table.from(rows).distinct();
      expect(t.nrow, 3);
      Table t2 = new Table.from(rows).distinct(columnNames: ['code']);
      equals(t2.nrow, 2);
    });

    test('print table', () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'code': 'BOS', 'value': 4}
      ];
      Table t = new Table.from(rows);
      expect(t.toString(), 'code value\n BOS     2\n BOS     4');
    });

    test('table toCsv()', () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'code': 'ATL', 'value': 4}
      ];
      Table t = new Table.from(rows);
      //print(t.toCsv());
      expect(t.toCsv(), 'code,value\r\nBOS,2\r\nATL,4');
    });


    test('adding a column with existing name throws', () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'code': 'BOS', 'value': 4}
      ];
      Table t = new Table.from(rows);
      expect(() => t.addColumn([10, 15], name: 'value'), throwsArgumentError);
    });

    test('remove columns', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30, 'Tmax': 95},
        {'code': 'BWI', 'Tmin': 32, 'Tmax': 100}
      ];
      Table t = new Table.from(rows);
      t.removeColumn('Tmin');
      expect(t.ncol, 2);
      t.removeColumn('Tmin');
      expect(t.ncol, 2);
    });

    test('remove two columns in cascade', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30, 'Tmax': 95},
        {'code': 'BWI', 'Tmin': 32, 'Tmax': 100}
      ];
      Table t = new Table.from(rows);
      t..removeColumn('Tmin')..removeColumn('Tmax');
      expect(t.ncol, 1);
    });

    test('add rows', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31}
      ];
      Table t = new Table.from(rows);
      t.addRow({'code': 'BOS', 'Tmin': 32});
      expect(t.nrow, 3);
    });

    test('add rows, filling with nulls', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31}
      ];
      Table t = new Table.from(rows);
      t.addRow({'Tmin': 32});
      expect(t.nrow, 3);
      expect(t['code'].data, ['BOS', 'BOS', null]);
    });

    test('remove rows', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
        {'code': 'BOS', 'Tmin': 32},
        {'code': 'BOS', 'Tmin': 33}
      ];
      Table t = new Table.from(rows);
      t.removeRow(1);
      expect(t.nrow, 3);
      expect(t.removeRow(5), false);
      Table t2 = new Table.from(t.where((Map e) => e['Tmin'] > 30));
      expect(t2.nrow, 2);
    });

    test('rbind', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
      ];
      Table t1 = new Table.from(rows);
      var rows2 = <Map>[
        {'code': 'BWI', 'Tmin': 33},
        {'code': 'BWI', 'Tmin': 34},
      ];
      Table t2 = new Table.from(rows2);
      Table t = t1.rbind(t2);
      expect([t.nrow, t.ncol], [4, 2]);
      //print(t);
    });
    test('rbind with out of order columns', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
      ];
      Table t1 = new Table.from(rows);
      var rows2 = <Map>[
        {'Tmin': 33, 'code': 'BWI'},
        {'Tmin': 34, 'code': 'BWI'},
      ];
      Table t2 = new Table.from(rows2);
      Table t = t1.rbind(t2);
      expect([t.nrow, t.ncol], [4, 2]);
      //print(t);
    });
    test('rbind with extra columns - non strict', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
      ];
      Table t1 = new Table.from(rows);
      var rows2 = <Map>[
        {'Tmax': 33, 'code': 'BWI'},
        {'Tmax': 34, 'code': 'BWI'},
      ];
      Table t2 = new Table.from(rows2);
      Table t = t1.rbind(t2, strict: false);
      expect([t.nrow, t.ncol], [4, 3]);
      expect(t['Tmin'].data, [30, 31, null, null]);
      expect(t['Tmax'].data, [null, null, 33, 34]);
      //print(t);
    });

    test('cbind', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
      ];
      Table t1 = new Table.from(rows);
      var rows2 = <Map>[
        {'Tmax': 33, 'code': 'BWI'},
        {'Tmax': 34, 'code': 'BWI'},
      ];
      Table t2 = new Table.from(rows2);
      Table t = t1.cbind(t2);
      //print(t);
      expect([t.nrow, t.ncol], [2, 4]);
      expect(t.colnames, ['code', 'Tmin', 'Tmax', 'code_Y']);
    });

    test('is rbind imutable?', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
      ];
      Table t1 = new Table.from(rows);
      Table t = t1.rbind(t1);
      expect([t.nrow, t.ncol], [4, 2]);
      // change t1 and check if t changes
      t1.column(1).data[0] = 100;
      expect(t['Tmin'][0], 30);
    });

//    test('order table', () {
//      var rows = <Map>[
//        {'code': 'BOS', 'Tmin': 31, 'Tmax': 95},
//        {'code': 'BWI', 'Tmin': 37, 'Tmax': 95},
//        {'code': 'BOS', 'Tmin': 30, 'Tmax': null},
//        {'code': 'BWI', 'Tmin': 32, 'Tmax': 100}
//      ];
//      Table t = new Table.from(rows);
//      Table to = t.order({'code': -1, 'Tmin': 1});
//      expect(to['code'].data, ['BWI', 'BWI', 'BOS', 'BOS']);
//      expect(to['Tmin'].data, [32, 37, 30, 31]);
//    });
//
//    test('order table 2', () {
//      var rows = <Map>[
//        {'code': 'BOS', 'Tmin': 31, 'Tmax': 95},
//        {'code': 'BWI', 'Tmin': 37, 'Tmax': 95},
//        {'code': 'BOS', 'Tmin': 30, 'Tmax': null},
//        {'code': 'BWI', 'Tmin': 32, 'Tmax': 100}
//      ];
//      Table t = new Table.from(rows);
//      Table t1 = t.order({'Tmin': 1});
//      expect(t1['code'].data, ['BOS', 'BOS', 'BWI', 'BWI']);
//      expect(t1['Tmin'].data, [30, 31, 32, 37]);
//
//      // order with nulls
//      Table t2 = t.order({'Tmax': -1});
//      expect(t2['Tmax'].data, [null, 100, 95, 95]);
//    });

    test('joins by one column', () {
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
      Table ti = t1.joinTable(t2, JoinType.inner);
      expect(ti.nrow, 2);
      expect(ti['code'].data, ['BOS', 'LAX']);
      expect(ti['Tmax'].data, [95, 82]);

      Table tl = t1.joinTable(t2, JoinType.left);
      expect(tl.nrow, 3);
      expect(tl['Tmax'].data, [95, 82, null]);

      Table tr = t1.joinTable(t2, JoinType.right);
      expect(tr.nrow, 3);
      expect(tr['code'].data, ['BOS', 'LAX', 'ORH']);
      expect(tr['Tmin'].data, [30, 49, null]);

      Table to = t1.joinTable(t2, JoinType.outer);
      expect(to.nrow, 4);
      expect(to['code'].data, ['BOS', 'LAX', 'BWI', 'ORH']);
      expect(to['Tmin'].data, [30, 49, 32, null]);
      expect(to['Tmax'].data, [95, 82, null, 92]);
    });

    test('group apply', () {
      Table t = new Table.from([
        {'code': 'BOS', 'month': 'Jan', 'day': 1, 'Tmin': 30, 'Tmax': 42},
        {'code': 'BOS', 'month': 'Jan', 'day': 2, 'Tmin': 31, 'Tmax': 43},
        {'code': 'BOS', 'month': 'Feb', 'day': 1, 'Tmin': 32, 'Tmax': 45},
        {'code': 'BOS', 'month': 'Feb', 'day': 2, 'Tmin': 35, 'Tmax': 47},
        {'code': 'BWI', 'month': 'Jan', 'day': 1, 'Tmin': 32, 'Tmax': 44},
        {'code': 'BWI', 'month': 'Jan', 'day': 2, 'Tmin': 33, 'Tmax': 45},
        {'code': 'BWI', 'month': 'Feb', 'day': 1, 'Tmin': 35, 'Tmax': 48},
        {'code': 'BWI', 'month': 'Feb', 'day': 2, 'Tmin': 37, 'Tmax': 50}
      ]);

      var gT1 = t.groupApply((x) => x.length,
          groupBy: ['month'], variables: ['Tmin', 'Tmax']);
      expect(gT1['Tmin'].data, [4, 4]);
      expect(gT1['Tmax'].data, [4, 4]);

      var gT2 = t.groupApply((x) => x.length,
          groupBy: ['month', 'code'], variables: ['Tmin', 'Tmax']);
      expect(gT2['Tmin'].data, [2, 2, 2, 2]);
      expect(gT2['Tmax'].data, [2, 2, 2, 2]);
    });

    test('group apply 2', () {
      Table t = new Table.from([
        {'farm': 'A', 'checked': true, 'meatType': 'poultry', 'quantity': 10},
        {'farm': 'A', 'checked': true, 'meatType': 'pork', 'quantity': 20},
        {'farm': 'A', 'checked': false, 'meatType': 'beef', 'quantity': 30},
        {'farm': 'B', 'checked': true, 'meatType': 'poultry', 'quantity': 15},
        {'farm': 'B', 'checked': false, 'meatType': 'pork', 'quantity': 25},
        {'farm': 'B', 'checked': true, 'meatType': 'beef', 'quantity': 35}
      ]);
      Function sum = (Iterable x) => x.reduce((a, b) => a + b);
      Table gT = t.groupApply(sum,
          groupBy: ['farm', 'checked'], variables: ['quantity']);
      expect(gT['farm'].data, ['A', 'A', 'B', 'B']);
      expect(gT['checked'].data, [true, false, true, false]);
      expect(gT['quantity'].data, [30, 30, 50, 25]);
    });

    test('melt table', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 34, 'Tmax': 95},
        {'code': 'BOS', 'Tmin': 30, 'Tmax': null},
        {'code': 'BWI', 'Tmin': 32, 'Tmax': 100}
      ];
      Table t = new Table.from(rows);
      Table tm = t.melt(['code']);
      expect(tm.nrow, 5);
      expect(tm['value'].data, [34, 30, 32, 95, 100]); // no nulls
    });

    test('cast table', () {
      Table t = new Table.from([
        {'code': 'BOS', 'variable': 'Tmin', 'value': 34},
        {'code': 'BOS', 'variable': 'Tmin', 'value': 32},
        {'code': 'BOS', 'variable': 'Tmax', 'value': 94},
        {'code': 'BWI', 'variable': 'Tmin', 'value': 30},
      ]);
      Table tc = t.reshape(['code'], ['variable'], (x) => x.length);
      expect(tc.nrow, 2);
      expect(tc['Tmax'].data, [1, null]);
    });

    test('cast table with 2 horizontal variables', () {
      Table t = new Table.from([
        {'code': 'BOS', 'variable': 'Tmin', 'id': 'A', 'value': 34},
        {'code': 'BOS', 'variable': 'Tmin', 'id': 'A', 'value': 32},
        {'code': 'BOS', 'variable': 'Tmax', 'id': 'B', 'value': 94},
        {'code': 'BWI', 'variable': 'Tmin', 'id': 'B', 'value': 30},
      ]);
      Table tc = t.reshape(['code'], ['id', 'variable'], (x) => x.length, fill: 0);
      //print(tc);
      expect(tc.nrow, 2);
      expect(tc['A_Tmin'].data, [2, 0]);
    });

    test('roll apply', () {
      DateTime startDt = new DateTime(2015);
      List days =
          new List.generate(10, (i) => startDt.add(new Duration(days: i)));
      Function sum = (Iterable x) => x.reduce((a, b) => a + b);
      Table t = new Table()
        ..addColumn(days, name: 'day')
        ..addColumn([0, 1, 0, 1, 2, 1, 3, 1, 2, 5], name: 'value');
      t..addColumn(t.rollApply('value', 3, sum), name: 'sum3');
      expect(t['sum3'].data, [null, null, 1, 2, 3, 4, 6, 5, 6, 8]);
    });
  });
}

speed_test() {
  Table t = new Table.fromCartesianProduct([
    new Column(new List.generate(10000, (i) => i), 'id'),
    new Column(new List.generate(24, (i) => i), 'hour'),
  ]);
  t.addColumn(new List.generate(240000, (i) => i ~/ 24), name: 'value');
  print(t.head());

  Function mean = (Iterable x) => x.reduce((a, b) => a + b) / x.length;
  Table agg = t.groupApply(mean, groupBy: ['id'], variables: ['value']);
  print(agg.head());
  print(agg.sample());
}

main() {
  table_simple();
  column_test();
  //speed_test();

//  Ordering ord = new Ordering.natural().nullsFirst();
//  List x = [1, null, 6, 3, 2];
//  print(ord.sorted(x));
}
