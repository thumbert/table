library test.expand_map_of_list_test;

import 'package:table/src/expand_map_of_list.dart';
import 'package:test/test.dart';

void tests() {
  group('columns to rows:', () {
    test('one column', () {
      var xs = {'values': [1, 2, 3]};
      var out = expandMapOfList(xs);
      expect(out, [
        {'values': 1},
        {'values': 2},
        {'values': 3},
      ]);
    });
    test('tow columns', () {
      var xs = {
        'month': ['2019-01', '2019-02', '2019-03'],
        'value': [1, 2, 3],
      };
      var out = expandMapOfList(xs);
      expect(out, [
        {'month': '2019-01', 'value': 1},
        {'month': '2019-02', 'value': 2},
        {'month': '2019-03', 'value': 3},
      ]);
    });
  });
}

void main() {
  tests();
}