library remove_columns_test;

import 'package:table/table.dart';
import 'package:test/test.dart';

void tests() {
  group('Remove columns', () {
    var xs = <Map<String, dynamic>>[
      {'year': 2016, 'tMin': 22.1, 'tMax': 98.9},
      {'year': 2018, 'tMin': 21.8, 'tMax': 111.3},
      {'year': 2019, 'tMin': 20.3, 'tMax': 108.9},
    ];
    test('simple', () {
      var res = removeColumns(xs, ['year', 'tMax']);
      expect(res.first.keys.toList(), ['tMin']);
    });
  });
}

void main() {
  tests();
}
