library test.unique_test;

import 'package:test/test.dart';
import 'package:table/table.dart';

void tests() {
  group('Unique list of maps:', (){
    var xs = <Map>[
      {'type': 'A', 'time': DateTime(2018), 'value': 10},
      {'type': 'A', 'time': DateTime(2018), 'value': 10},
      {'type': 'B', 'time': DateTime(2018), 'value': 10},
    ];
    test('no names', (){
      var res = unique(xs);
      expect(res.length, 2);
    });
    test('with one name', (){
      var res = unique(xs, keys: ['type']);
      expect(res.length, 2);
      expect(res, [{'type': 'A'}, {'type': 'B'},]);
    });
    test('with two names', (){
      xs.add({'type': 'A', 'time': DateTime(2019), 'value': 10});
      var res = unique(xs, keys: ['type', 'time']);
      var out = [
        {'type': 'A', 'time': DateTime(2018)},
        {'type': 'B', 'time': DateTime(2018)},
        {'type': 'A', 'time': DateTime(2019)},];
      expect(res.length, 3);
      expect(res, out);
    });
  });
}

void main() {
  tests();
}
