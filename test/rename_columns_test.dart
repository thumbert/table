library rename_columns_test;

import 'package:table/table.dart';
import 'package:test/test.dart';

void tests() {
  group('Rename columns', () {
    var xs = <Map<String, dynamic>>[
      {'year': 2016, 'tMin': 22.1, 'tMax': 98.9},
      {'year': 2018, 'tMin': 21.8, 'tMax': 111.3},
      {'year': 2019, 'tMin': 20.3, 'tMax': 108.9},
    ];
    test('simple renaming', () {
      var res = renameColumns(xs, {
        'tMax': 'Max Temperature',
        'tMin': 'Min Temperature',
      });
      expect(res.first.keys.toList(),
          ['year', 'Min Temperature', 'Max Temperature']);
    });
  });
}

void main() {
  tests();
}
