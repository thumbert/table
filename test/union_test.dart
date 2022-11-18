library test.unique_test;

import 'package:test/test.dart';
import 'package:table/table.dart';

void tests() {
  group('Union of two list of maps:', (){
    var xs = [
      {'type': 'A', 'time': DateTime(2018), 'value': 10},
      {'type': 'B', 'time': DateTime(2018), 'value': 12},
      {'type': 'C', 'time': DateTime(2018), 'value': 15},
    ];
    var ys = [
      {'type': 'B', 'time': DateTime(2018), 'value': 12},
      {'type': 'C', 'time': DateTime(2018), 'value': 15},
      {'type': 'D', 'time': DateTime(2020), 'value': 20},
    ];

    test('union', (){
      var res = union(xs, ys);
      var out = [
        {'type': 'A', 'time': DateTime(2018), 'value': 10},
        {'type': 'B', 'time': DateTime(2018), 'value': 12},
        {'type': 'C', 'time': DateTime(2018), 'value': 15},
        {'type': 'D', 'time': DateTime(2020), 'value': 20},
      ];
      expect(res.length, 4);
      expect(res, out);
    });
  });
}

void main() {
  tests();
}
