library test.sort_test;

import 'package:more/more.dart';
import 'package:test/test.dart';

void tests() {
  group('Sort: ', () {
    test('one column reversed', () {
      var xs = <Map<String, dynamic>>[
        {'code': 'BOS', 'Tmin': 31, 'Tmax': 95},
        {'code': 'BWI', 'Tmin': 37, 'Tmax': 95},
        {'code': 'BOS', 'Tmin': 30, 'Tmax': null},
        {'code': 'BWI', 'Tmin': 32, 'Tmax': 100}
      ];

      var ord = naturalComparable<String>
          .reversed
          .onResultOf((Map<String, dynamic> x) => x['code']!);
      var res = ord.sorted(xs);
      expect(res.map((e) => e['code']).toList(), ['BWI', 'BWI', 'BOS', 'BOS']);
    });


    test('by two columns, one reversed, other nulls first', () {
      var xs = <Map<String, dynamic>>[
        {'code': 'BOS', 'Tmin': 31, 'Tmax': 95},
        {'code': 'BWI', 'Tmin': 37, 'Tmax': 96},
        {'code': 'BOS', 'Tmin': 30, 'Tmax': null},
        {'code': 'BWI', 'Tmin': 32, 'Tmax': 100}
      ];

      var byCode = naturalComparable<String>
          .reversed
          .onResultOf((Map<String, dynamic> x) => x['code']);
      var byTmax = naturalComparable<num>
          .nullsLast
          .onResultOf((Map<String, dynamic> x) => x['Tmax']);

      var comparator = byCode.thenCompare(byTmax);
      var res = comparator.sorted(xs);

      expect(res.map((e) => e['code']).toList(), ['BWI', 'BWI', 'BOS', 'BOS']);
      expect(res.map((e) => e['Tmax']).toList(), [96, 100, 95, null]);
    });
  });
}

void main() {
  tests();
}
