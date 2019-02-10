library reorder_columns_test;

import 'package:test/test.dart';
import 'package:table/src/reorder_columns.dart';

tests() {
  group('Reorder columns', (){
    var xs = <Map<String,dynamic>>[
      {'year': 2016, 'tMin': 22.1, 'tMax': 98.9},
      {'year': 2018, 'tMin': 21.8, 'tMax': 111.3},
      {'year': 2019, 'tMin': 20.3, 'tMax': 108.9},
    ];
    test('simple reordering', (){
      var res = reorderColumns(xs, ['year', 'tMax', 'tMin']);
      expect(res.first.keys.toList(), ['year', 'tMax', 'tMin']);
    });
    test('reordering with fewer columns', (){
      var res = reorderColumns(xs, ['year', 'tMax']);
      expect(res.first.keys.toList(), ['year', 'tMax']);
    });
    test('reordering with a non existing column throws', (){
      expect(() => reorderColumns(xs, ['year', 'tMax', 'wMax']),
          throwsArgumentError);
    });
  });
}

main() {
  tests();
}