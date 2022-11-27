library test.collapse_list_of_map_test;

import 'package:table/src/collapse_list_of_map.dart';
import 'package:test/test.dart';

void tests() {
  group('rows to columns:', () {
    test('one column', () {
      var xs = [
        {'values': 1},
        {'values': 2},
        {'values': 3},
      ];
      var out = collapseListOfMap(xs);
      expect(out, {'values': [1, 2, 3]});
    });
    test('two columns', () {
      var xs = [
        {'month': '2019-01', 'value': 1},
        {'month': '2019-02', 'value': 2},
        {'month': '2019-03', 'value': 3},
      ];
      var out = collapseListOfMap(xs);
      expect(out, {
        'month': ['2019-01', '2019-02', '2019-03'],
        'value': [1, 2, 3],
      });
    });
    test('three columns', () {
      var xs = [
        {'month': '2019-01', 'type': 'A', 'value': 1},
        {'month': '2019-02', 'type': 'A', 'value': 2},
        {'month': '2019-03', 'type': 'B', 'value': 3},
      ];
      var out = collapseListOfMap(xs, columns: ['month', 'value']);
      expect(out, {
        'month': ['2019-01', '2019-02', '2019-03'],
        'value': [1, 2, 3],
      });
    });

  });
}

void main() {
  tests();
}