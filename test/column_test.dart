library test.column;

import 'dart:math';

import 'package:table/src/column.dart';
import 'package:test/test.dart';

void tests() {
  group('Column tests', () {
    test('print column, string', () {
      var c = Column(['BWI', 'BOS', 'DC'], 'airport');
      expect(c.toString(), 'airport\n    BWI\n    BOS\n     DC');
    });
    test('print column, integer', () {
      var c = Column([1, 2, 100], 'index');
      expect(c.toString(), 'index\n    1\n    2\n  100');
    });
    test('print column, integer with nulls', () {
      var c = Column([1, 2, 121134, null, 45], 'index');
      expect(c.toString(), ' index\n     1\n     2\n121134\n  null\n    45');
    });
    test('print column, integer with nulls and custom null treatment', () {
      var c = Column([1, 2, 121134, null, 45], 'index');
      expect(c.toString(nullToString: ''),
          ' index\n     1\n     2\n121134\n      \n    45');
    });
    test('print column, double', () {
      var c = Column([sqrt(2), pi, 100.0], 'value');
      expect(c.toString(), '     value\n  1.414214\n  3.141593\n100.000000');
    });
    test('print column, double with few decimals', () {
      var c = Column([14.5, 2.4, 100.0], 'value');
      expect(c.toString(), 'value\n 14.5\n  2.4\n100.0');
    });
    test('print column, double with exact decimals', () {
      var c = Column([14.512, 2.412, 100.012], 'value');
      expect(c.toString(format: (e) => e!.toStringAsFixed(3)), '  value\n 14.512\n  2.412\n100.012');
    });
    test('print column, exact decimals and nullToString overrides format', () {
      var c = Column([14.512, null, 100.012], 'value');
      expect(c.toString(format: (e) => e!.toStringAsFixed(3), nullToString: ''),
          '  value\n 14.512\n       \n100.012');
    });
    test('print column, with correct format specification', () {
      var c = Column([14.512, null, 100.012], 'value');
      expect(c.toString(format: (e) => e == null ? 'nil' : e.toStringAsFixed(3)),
          '  value\n 14.512\n    nil\n100.012');
    });
    test('column with specified width', () {
      var c = Column(['Ohio', 'Maryland', 'Arizona'], 'state');
      expect(
          c.toString(width: 15),
          '          state\n'
              '           Ohio\n'
              '       Maryland\n'
              '        Arizona');
    });
  });
}

void main() {
  tests();
}
