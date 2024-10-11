// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library table.test;

import 'dart:math';

import 'package:table/src/column.dart';
import 'package:test/test.dart';
import 'package:table/table_base.dart';

void table_simple() {
  group('table: ', () {
    test('construct an empty table', () {
      var t = Table();
      expect(t.nrow, 0);
      expect(t.ncol, 0);
    });

    test('construct an empty table with column names', () {
      var t = Table(colnames: ['code', 'Tmin']);
      expect(t.nrow, 0);
      expect(t.ncol, 2);
    });

    test('construct table with one column', () {
      var t = Table()..addColumn([1, 2, 3], name: 'int');
      expect(t.nrow, 3);
      expect(t.ncol, 1);
    });

    test('construct table with two columns', () {
      var t = Table()
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
      var t = Table.from(rows);
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
      var t = Table.from(rows);
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
      var t = Table.from(rows);
      expect(t.nrow, 2);
      expect(t.ncol, 3);
      expect(t.colnames, ['code', 'value', 'Tmin']);
      expect(t['value'].data, [2, null]);
      expect(t['Tmin'].data, [null, 24]);
    });

    test('construct table from cartesian product', () {
      var t = Table.fromCartesianProduct([
        Column(['BWI', 'BOS', 'LAX'], 'code'),
        Column(['Tmin', 'Tmax'], 'variable'),
        Column(['A', 'B'], 'equipment')
      ]);
      expect(t.nrow, 12);
      expect(t['equipment'].data,
          ['A', 'B', 'A', 'B', 'A', 'B', 'A', 'B', 'A', 'B', 'A', 'B']);
      //print(t);
    });

    test('print table, simple', () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'code': 'BOS', 'value': 4}
      ];
      var t = Table.from(rows);
      expect(t.toString(), 'code value\n BOS     2\n BOS     4');
    });

    test('print table, different column types', () {
      var rows = <Map>[
        {'tree': 'Oak', 'age': 2.5, 'diameter': 10.001},
        {'tree': 'Maple', 'age': 4.1, 'diameter': 13.452},
      ];
      var t = Table.from(rows);
      expect(t.toString(),
          ' tree age diameter\n  Oak 2.5   10.001\nMaple 4.1   13.452');
    });

    test('print table, custom format', () {
      var rows = <Map>[
        {'int': 1, 'value': sqrt(1)},
        {'int': 2, 'value': sqrt2},
      ];
      var options = {
        'columnSeparation': '  ',
        'format': {'value': (e) => (e as double).toStringAsPrecision(6)},
      };
      var t = Table.from(rows, options: options);
      expect(t.toString(), 'int    value\n  1  1.00000\n  2  1.41421');
    });

    test('print table, custom format and columnWidth', () {
      var rows = [
        {'state': 'Ohio', 'value': sqrt(1)},
        {'state': 'Maryland', 'value': sqrt2},
      ];
      var options = {
        'columnSeparation': '  ',
        'format': {'value': (e) => (e as double).toStringAsPrecision(6)},
        'columnWidth': {'state': 15},
      };
      var t = Table.from(rows, options: options);
      // print(t.toString());
      expect(
          t.toString(),
          '          state    value\n'
          '           Ohio  1.00000\n'
          '       Maryland  1.41421');
    });

    test('print table with missing observations (issue 3)', () {
      var tbl = Table.from([
        {'year': 2021, '10': 42, '11': 37, '12': 35},
        {'year': 2022, '1': 28, '2': 31, '3': 36},
      ], options: {
        'nullToString': '',
      });
      tbl.reorderColumns(['year', '1', '2', '3', '10', '11', '12']);
      expect(
          tbl.toString(),
          'year  1  2  3 10 11 12\n'
          '2021          42 37 35\n'
          '2022 28 31 36         ');
    });

    test('table toCsv()', () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'code': 'ATL', 'value': 4}
      ];
      var t = Table.from(rows);
      expect(t.toCsv(), 'code,value\r\nBOS,2\r\nATL,4');
    });

    test('table toCsv() with nulls', () {
      var rows = [
        {
          'code': 'BOS',
          'value': 23.0
        }, // NOTE: first value makes the column double!
        {'code': 'BWI', 'value': null},
        {'code': 'ORD', 'value': 0 / 0},
        {'code': 'ATL', 'value': 144}
      ];
      var t = Table.from(rows, options: {
        'nullToString': '',
      });
      expect(t.toCsv(), 'code,value\r\nBOS,23.0\r\nBWI,\r\nORD,NaN\r\nATL,144');
    });

    test('table toCsv() with nulls, using default value', () {
      var rows = [
        {
          'code': 'BOS',
          'value': 23.0
        }, // NOTE: first value makes the column double!
        {'code': 'BWI', 'value': null},
        {'code': 'ORD', 'value': 0 / 0},
        {'code': 'ATL', 'value': 144}
      ];
      var t = Table.from(rows);
      expect(t.toCsv(), 'code,value\r\nBOS,23.0\r\nBWI,\r\nORD,NaN\r\nATL,144');
    });

    test('table toCsv() for data that has commas', () {
      var rows = [
        {'variable': 'Median', 'value': 100.5},
        {'variable': 'Mean, 10 years', 'value': 112.7},
      ];
      var t = Table.from(rows);
      expect(t.toCsv(),
          'variable,value\r\nMedian,100.5\r\n"Mean, 10 years",112.7');
    });

    test('row iterator', () {
      var t = Table()
        ..addColumn(['BWI', 'BWI', 'BOS'], name: 'code')
        ..addColumn([1, 2, 3], name: 'value');
      Iterator it = t.iterator;
      expect(it.current, null);
      it.moveNext();
      expect(it.current, {'code': 'BWI', 'value': 1});
    });

    test('row filtering with where', () {
      var t = Table()
        ..addColumn(['BWI', 'BOS', 'BWI', 'BOS'], name: 'code')
        ..addColumn([1, 2, 3, 4], name: 'value');
      expect(t.where((e) => e!['code'] == 'BOS').toList(), [
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
      var t = Table.from(rows).distinct();
      expect(t.nrow, 3);
      var t2 = Table.from(rows).distinct(columnNames: ['code']);
      equals(t2.nrow, 2);
    });

    test('adding a column with existing name throws', () {
      var rows = <Map>[
        {'code': 'BOS', 'value': 2},
        {'code': 'BOS', 'value': 4}
      ];
      var t = Table.from(rows);
      expect(() => t.addColumn([10, 15], name: 'value'), throwsArgumentError);
    });

    test('remove columns', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30, 'Tmax': 95},
        {'code': 'BWI', 'Tmin': 32, 'Tmax': 100}
      ];
      var t = Table.from(rows);
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
      var t = Table.from(rows);
      t
        ..removeColumn('Tmin')
        ..removeColumn('Tmax');
      expect(t.ncol, 1);
    });

    test('reorder columns', () {
      var rows = [
        {'year': 2020, 'BOS': 30, 'ATL': 95},
        {'year': 2021, 'BOS': 32, 'ATL': 100}
      ];
      var t = Table.from(rows);
      t.reorderColumns(['year', 'ATL', 'BOS']);
      expect(t.ncol, 3);
      expect(t.colnames, ['year', 'ATL', 'BOS']);
      expect(t.toString(), 'year ATL BOS\n2020  95  30\n2021 100  32');
    });

    test('add rows', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31}
      ];
      var t = Table.from(rows);
      t.addRow({'code': 'BOS', 'Tmin': 32});
      expect(t.nrow, 3);
    });

    test('add rows, filling with nulls', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31}
      ];
      var t = Table.from(rows);
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
      var t = Table.from(rows);
      t.removeRow(1);
      expect(t.nrow, 3);
      expect(t.removeRow(5), false);
      var t2 = Table.from(t.where((Map? e) => e!['Tmin'] > 30));
      expect(t2.nrow, 2);
    });

    test('rbind', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
      ];
      var t1 = Table.from(rows);
      var rows2 = <Map>[
        {'code': 'BWI', 'Tmin': 33},
        {'code': 'BWI', 'Tmin': 34},
      ];
      var t2 = Table.from(rows2);
      var t = t1.rbind(t2);
      expect([t.nrow, t.ncol], [4, 2]);
      //print(t);
    });
    test('rbind with out of order columns', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
      ];
      var t1 = Table.from(rows);
      var rows2 = <Map>[
        {'Tmin': 33, 'code': 'BWI'},
        {'Tmin': 34, 'code': 'BWI'},
      ];
      var t2 = Table.from(rows2);
      var t = t1.rbind(t2);
      expect([t.nrow, t.ncol], [4, 2]);
      //print(t);
    });
    test('rbind with extra columns - non strict', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
      ];
      var t1 = Table.from(rows);
      var rows2 = <Map>[
        {'Tmax': 33, 'code': 'BWI'},
        {'Tmax': 34, 'code': 'BWI'},
      ];
      var t2 = Table.from(rows2);
      var t = t1.rbind(t2, strict: false);
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
      var t1 = Table.from(rows);
      var rows2 = <Map>[
        {'Tmax': 33, 'code': 'BWI'},
        {'Tmax': 34, 'code': 'BWI'},
      ];
      var t2 = Table.from(rows2);
      var t = t1.cbind(t2);
      //print(t);
      expect([t.nrow, t.ncol], [2, 4]);
      expect(t.colnames, ['code', 'Tmin', 'Tmax', 'code_Y']);
    });

    test('table copy', () {
      var t = Table.from([
        {'year': 2020, 'BOS': 30, 'ATL': 95},
        {'year': 2021, 'BOS': 32, 'ATL': 100}
      ]);
      var t2 = t.copy();
      expect(t2.colnames, ['year', 'BOS', 'ATL']);
      expect(t2.nrow, 2);

      var t3 = t.copy(colnames: ['year', 'ATL']);
      expect(t3.colnames, ['year', 'ATL']);
      expect(t3.nrow, 2);

      // copy also reorders
      var t4 = t.copy(colnames: ['ATL', 'BOS']);
      expect(t4.colnames, ['ATL', 'BOS']);
      expect(t4.nrow, 2);
    });

    test('is rbind imutable?', () {
      var rows = <Map>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BOS', 'Tmin': 31},
      ];
      var t1 = Table.from(rows);
      var t = t1.rbind(t1);
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
//      var t = Table.from(rows);
//      var to = t.order({'code': -1, 'Tmin': 1});
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
//      var t = Table.from(rows);
//      var t1 = t.order({'Tmin': 1});
//      expect(t1['code'].data, ['BOS', 'BOS', 'BWI', 'BWI']);
//      expect(t1['Tmin'].data, [30, 31, 32, 37]);
//
//      // order with nulls
//      var t2 = t.order({'Tmax': -1});
//      expect(t2['Tmax'].data, [null, 100, 95, 95]);
//    });

    test('joins by one column', () {
      var t1 = Table.from([
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BWI', 'Tmin': 32},
        {'code': 'LAX', 'Tmin': 49}
      ]);
      var t2 = Table.from([
        {'code': 'BOS', 'Tmax': 95},
        {'code': 'ORH', 'Tmax': 92},
        {'code': 'LAX', 'Tmax': 82}
      ]);
      var ti = t1.joinTable(t2, JoinType.inner);
      expect(ti.nrow, 2);
      expect(ti['code'].data, ['BOS', 'LAX']);
      expect(ti['Tmax'].data, [95, 82]);

      var tl = t1.joinTable(t2, JoinType.left);
      expect(tl.nrow, 3);
      expect(tl['Tmax'].data, [95, 82, null]);

      var tr = t1.joinTable(t2, JoinType.right);
      expect(tr.nrow, 3);
      expect(tr['code'].data, ['BOS', 'LAX', 'ORH']);
      expect(tr['Tmin'].data, [30, 49, null]);

      var to = t1.joinTable(t2, JoinType.outer);
      expect(to.nrow, 4);
      expect(to['code'].data, ['BOS', 'LAX', 'BWI', 'ORH']);
      expect(to['Tmin'].data, [30, 49, 32, null]);
      expect(to['Tmax'].data, [95, 82, null, 92]);
    });

    test('group apply', () {
      var t = Table.from([
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
      var t = Table.from([
        {'farm': 'A', 'checked': true, 'meatType': 'poultry', 'quantity': 10},
        {'farm': 'A', 'checked': true, 'meatType': 'pork', 'quantity': 20},
        {'farm': 'A', 'checked': false, 'meatType': 'beef', 'quantity': 30},
        {'farm': 'B', 'checked': true, 'meatType': 'poultry', 'quantity': 15},
        {'farm': 'B', 'checked': false, 'meatType': 'pork', 'quantity': 25},
        {'farm': 'B', 'checked': true, 'meatType': 'beef', 'quantity': 35}
      ]);
      Function sum = (Iterable x) => x.reduce((a, b) => a + b);
      var gT = t.groupApply(sum as dynamic Function(Iterable<dynamic>),
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
      var t = Table.from(rows);
      var tm = t.melt(['code']);
      expect(tm.nrow, 5);
      expect(tm['value'].data, [34, 30, 32, 95, 100]); // no nulls
    });

    test('cast table', () {
      var t = Table.from([
        {'code': 'BOS', 'variable': 'Tmin', 'value': 34},
        {'code': 'BOS', 'variable': 'Tmin', 'value': 32},
        {'code': 'BOS', 'variable': 'Tmax', 'value': 94},
        {'code': 'BWI', 'variable': 'Tmin', 'value': 30},
      ]);
      var tc = t.reshape(['code'], ['variable'], (x) => x.length);
      expect(tc.nrow, 2);
      expect(tc['Tmax'].data, [1, null]);
    });

    test('cast table with 2 horizontal variables', () {
      var t = Table.from([
        {'code': 'BOS', 'variable': 'Tmin', 'id': 'A', 'value': 34},
        {'code': 'BOS', 'variable': 'Tmin', 'id': 'A', 'value': 32},
        {'code': 'BOS', 'variable': 'Tmax', 'id': 'B', 'value': 94},
        {'code': 'BWI', 'variable': 'Tmin', 'id': 'B', 'value': 30},
      ]);
      var tc =
          t.reshape(['code'], ['id', 'variable'], (x) => x.length, fill: 0);
      //print(tc);
      expect(tc.nrow, 2);
      expect(tc['A_Tmin'].data, [2, 0]);
    });

    test('roll apply', () {
      var startDt = DateTime(2015);
      var days = List.generate(10, (i) => startDt.add(Duration(days: i)));
      Function sum = (Iterable x) => x.reduce((a, b) => a + b);
      var t = Table()
        ..addColumn(days, name: 'day')
        ..addColumn([0, 1, 0, 1, 2, 1, 3, 1, 2, 5], name: 'value');
      t.addColumn(t.rollApply('value', 3, sum), name: 'sum3');
      expect(t['sum3'].data, [null, null, 1, 2, 3, 4, 6, 5, 6, 8]);
    });
  });
}

void table_html() {
  group('Table toHtml() method', () {
    test('simple table', () {
      var tbl = Table.from([
        {
          'region': 'CAISO',
          'value': 83499,
        },
        {
          'region': 'PJM',
          'value': 423412,
        },
        {
          'region': 'ISONE',
          'value': 84271.34,
        },
      ]);
      var out = tbl.toHtml();
      expect(out, '''<table>
<thead>
<tr><th>region</th><th>value</th></tr>
</thead>
<tbody>
<tr><td>CAISO</td><td>83499</td></tr>
<tr><td>PJM</td><td>423412</td></tr>
<tr><td>ISONE</td><td>84271.34</td></tr>
</tbody>
</table>
''');
    });

    test('table with class name, caption, and extra headers ', () {
      var tbl = Table.from([
        {
          'Term': 'Jan22-Mar22',
          'HourCharging': 1,
          'CountCharging': 20,
          'HourDischarging': 17,
          'CountDischarging': 22,
        },
        {
          'Term': 'Jan22-Mar22',
          'HourCharging': 0,
          'CountCharging': 16,
          'HourDischarging': 16,
          'CountDischarging': 20,
        },
      ]);
      var out = tbl.toHtml(
          className: 'best-blocks-table',
          caption: '<b>Table:</b>An amazing table',
          includeColumnNames: false,
          extraHeaders: [
            '''
  <tr>
    <th> </th>
    <th colspan="2" style="background-color: #ffb3b3;">Charging</th>
    <th colspan="2" style="background-color: #9fdfbf;">Discharging</th>
  </tr>
''',
            '''
  <tr>
    <th>Term</th>
    <th>Hour</th>
    <th>Count</th>
    <th>Hour</th>
    <th>Count</th>
  </tr>
''',
          ]);
      // print(out);
      expect(out.contains('class='), true);
      expect(out.contains('<caption>'), true);
      expect(out.contains('Term'), true);
    });
  });
}

void speed_test() {
  var t = Table.fromCartesianProduct([
    Column(List.generate(10000, (i) => i), 'id'),
    Column(List.generate(24, (i) => i), 'hour'),
  ]);
  t.addColumn(List.generate(240000, (i) => i ~/ 24), name: 'value');
  print(t.head());

  Function mean = (Iterable x) => x.reduce((a, b) => a + b) / x.length;
  var agg = t.groupApply(mean as dynamic Function(Iterable<dynamic>),
      groupBy: ['id'], variables: ['value']);
  print(agg.head());
  print(agg.sample());
}

void main() {
  table_simple();
  table_html();
  //speed_test();

//  Ordering ord = Ordering.natural().nullsFirst();
//  List x = [1, null, 6, 3, 2];
//  print(ord.sorted(x));
}
