library melt_test;

import 'package:test/test.dart';
import 'package:table/table.dart' as table;

void tests() {
  group('Melt', () {
    test('no variables', () {
      var xs = <Map<String, dynamic>>[
        {'version': 0},
        {'version': 1},
        {'version': 2},
      ];
      var out = table.melt(xs, {}, {'version'}, value: 'value');
      expect(out, [
        {'variable': 'version', 'value': 0},
        {'variable': 'version', 'value': 1},
        {'variable': 'version', 'value': 2},
      ]);
    });
    test('one variables', () {
      var xs = <Map<String, dynamic>>[
        {'airport': 'BWI', 'Tmax': 90, 'Tmin': 30},
        {'airport': 'BOS', 'Tmax': 93, 'Tmin': 15},
      ];
      var out = table.melt(xs, {'airport'}, {'Tmax', 'Tmin'}, value: 'value');
      expect(out, [
        {'airport': 'BWI', 'variable': 'Tmax', 'value': 90},
        {'airport': 'BWI', 'variable': 'Tmin', 'value': 30},
        {'airport': 'BOS', 'variable': 'Tmax', 'value': 93},
        {'airport': 'BOS', 'variable': 'Tmin', 'value': 15},
      ]);
    });


  });
}


void main() {
  tests();
}


