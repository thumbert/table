library test.sort_test;

import 'package:test/test.dart';
import 'package:more/ordering.dart';

tests() {
  group('Sort', () {
    test('one column reversed', () {
      var xs = <Map<String, dynamic>>[
        {'code': 'BOS', 'Tmin': 31, 'Tmax': 95},
        {'code': 'BWI', 'Tmin': 37, 'Tmax': 95},
        {'code': 'BOS', 'Tmin': 30, 'Tmax': null},
        {'code': 'BWI', 'Tmin': 32, 'Tmax': 100}
      ];
      var ord = Ordering.natural<String>()
          .reversed
          .onResultOf((Map<String, dynamic> x) => x['code']!);
      var res = ord.sorted(xs);
      expect(res.map((e) => e['code']).toList(), ['BWI', 'BWI', 'BOS', 'BOS']);
    });
  });
}

main() {
  tests();
}
