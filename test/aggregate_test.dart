library test.aggregate_test;

import 'package:table/src/aggregate.dart';
import 'package:test/test.dart';
import 'package:dama/dama.dart';

void tests() {
  group('Aggregate:', () {
    var xs = [
      {'code': 'BWI', 'month': 1, 'Tmax': 65, 'Tmin': 2},
      {'code': 'BWI', 'month': 1, 'Tmax': 64, 'Tmin': 3},
      {'code': 'BWI', 'month': 2, 'Tmax': 67, 'Tmin': 1},
      {'code': 'BWI', 'month': 2, 'Tmax': 68, 'Tmin': 5},
      {'code': 'BOS', 'month': 1, 'Tmax': 65, 'Tmin': -2},
      {'code': 'BOS', 'month': 1, 'Tmax': 64, 'Tmin': -3},
      {'code': 'BOS', 'month': 2, 'Tmax': 67, 'Tmin': -1},
      {'code': 'BOS', 'month': 2, 'Tmax': 62, 'Tmin': -7},
    ];
    test('no groupBy variable', () {
      var out = aggregate(xs, [], ['Tmax', 'Tmin'], mean);
      expect(out, [
        {'Tmax': 65.25, 'Tmin': -0.25},
      ]);
    });
    test('one groupBy variable', () {
      var out = aggregate(xs, ['code'], ['Tmax', 'Tmin'], mean);
      expect(out, [
        {'code': 'BWI', 'Tmax': 66.0, 'Tmin': 2.75},
        {'code': 'BOS', 'Tmax': 64.5, 'Tmin': -3.25},
      ]);
    });
    test('two groupBy variables', () {
      var out = aggregate(xs, ['code', 'month'], ['Tmax'], mean);
      expect(out, [
        {'code': 'BWI', 'month': 1, 'Tmax': 64.5},
        {'code': 'BWI', 'month': 2, 'Tmax': 67.5},
        {'code': 'BOS', 'month': 1, 'Tmax': 64.5},
        {'code': 'BOS', 'month': 2, 'Tmax': 64.5},
      ]);
    });
    test('deal with nulls', () {
      var xs = [
        {'code': 'BWI', 'month': 1, 'Tmax': 65, 'Tmin': 2},
        {'code': 'BWI', 'month': 1, 'Tmax': null, 'Tmin': 3},
        {'code': 'BWI', 'month': 2, 'Tmax': 67, 'Tmin': 1},
      ];
      var out = aggregate(xs, ['code'], ['Tmax'],
          (zs) => mean(zs.where((e) => e != null)));
      expect(out, [
        {'code': 'BWI', 'Tmax': 66.0},
      ]);

    });
  });
}

void main() {
  tests();
}
