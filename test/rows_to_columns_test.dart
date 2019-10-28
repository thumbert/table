library test.rows_to_columns;

import 'package:table/src/rows_to_columns.dart';
import 'package:test/test.dart';

tests() {
  group('rows to columns:', () {
    test('one column', () {
      var xs = [
        {'values': 1},
        {'values': 2},
        {'values': 3},
      ];
      var out = rowsToColumns(xs);
      expect(out, {'values': [1, 2, 3]});
    });
    test('tow columns', () {
      var xs = [
        {'month': '2019-01', 'value': 1},
        {'month': '2019-02', 'value': 2},
        {'month': '2019-03', 'value': 3},
      ];
      var out = rowsToColumns(xs);
      expect(out, {
        'month': ['2019-01', '2019-02', '2019-03'],
        'value': [1, 2, 3],
      });
    });

  });
}

main() {
  tests();
}