library reshape_test;

import 'package:test/test.dart';
import 'package:table/table.dart' as table;

void tests() {
  group('Reshape', () {
    test('table with just one column', () {
      var xs = <Map<String, dynamic>>[
        {'version': 0, 'value': 0},
        {'version': 1, 'value': 2},
        {'version': 2, 'value': 4},
      ];
      var out = table.reshape(xs, [], ['version'], 'value');
      expect(out, [
        {'0': 0, '1': 2, '2': 4}
      ]);
    });
    test('table with one column, one variable', () {
      var xs = <Map<String, dynamic>>[
        {'entity': 'A', 'version': 0, 'value': 0.0},
        {'entity': 'B', 'version': 0, 'value': 0.5},
        {'entity': 'C', 'version': 0, 'value': 0.7},
        {'entity': 'A', 'version': 1, 'value': 1.0},
        {'entity': 'B', 'version': 1, 'value': 1.5},
        {'entity': 'C', 'version': 1, 'value': 1.7},
      ];
      var out = table.reshape(xs, ['entity'], ['version'], 'value');
      expect(out, [
        {'entity': 'A', '0': 0.0, '1': 1.0},
        {'entity': 'B', '0': 0.5, '1': 1.5},
        {'entity': 'C', '0': 0.7, '1': 1.7},
      ]);
    });
    test('table with one column, one variable, missing values', () {
      var xs = <Map<String, dynamic>>[
        {'entity': 'A', 'version': 0, 'value': 0.0},
        {'entity': 'C', 'version': 0, 'value': 0.7},
        {'entity': 'A', 'version': 1, 'value': 1.0},
        {'entity': 'B', 'version': 1, 'value': 1.5},
      ];
      var out = table.reshape(xs, ['entity'], ['version'], 'value');
      // out has already the missing cells filled, what are you doing below?
      var mis = table.addMissing(out);
      mis.sort((a,b) => a['entity'].compareTo(b['entity']));
      expect(mis, [
        {'entity': 'A', '0': 0.0, '1': 1.0},
        {'entity': 'B', '0': null, '1': 1.5},
        {'entity': 'C', '0': 0.7, '1': null},
      ]);
    });

  });
}


void main() {
  tests();
}


