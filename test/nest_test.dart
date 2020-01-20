library test.nest;

import 'package:table/src/nest.dart';
import 'package:test/test.dart';
import 'data.dart';

void barleyTests() {

}

void tests() {
  group('Nest tests:', () {
    test('nest entries return the input in input order', () {
      var nest = Nest();
      expect(nest.entries([1, 2, 3]), [1, 2, 3]);
      expect(nest.entries([1, 3, 2]), [1, 3, 2]);
      expect(nest.entries([3, 2, 1]), [3, 2, 1]);
    });

    var a = {'foo': 1, 'bar': 'a'};
    var b = {'foo': 1, 'bar': 'a'};
    var c = {'foo': 2, 'bar': 'a'};
    var d = {'foo': 1, 'bar': 'b'};
    var e = {'foo': 1, 'bar': 'b'};
    var f = {'foo': 2, 'bar': 'b'};
    test('nest one level, get entries', () {
      var nest = Nest()..key((e) => e['foo']);
      List<Map> res = nest.entries([a, b, c, d, e, f]);
      //res.forEach(print);
      expect(res.firstWhere((Map e) => e['key'] == 1)['values'].length, 4);
      expect(res.firstWhere((Map e) => e['key'] == 2)['values'].length, 2);
      expect(res, [
        {
          'key': 1,
          'values': [a, b, d, e]
        },
        {
          'key': 2,
          'values': [c, f]
        }
      ]);
    });

    test('nest two levels, get entries', () {
      var nest = Nest()..key((e) => e['foo'])..key((e) => e['bar']);
      List res = nest.entries([a, b, c, d, e, f]);
      //res.forEach(print);
      expect(res, [
        {
          'key': 1,
          'values': [
            {
              'key': 'a',
              'values': [a, b]
            },
            {
              'key': 'b',
              'values': [d, e]
            },
          ]
        },
        {
          'key': 2,
          'values': [
            {
              'key': 'a',
              'values': [c]
            },
            {
              'key': 'b',
              'values': [f]
            },
          ]
        }
      ]);
    });

    test(
        'nest.rollup(rollup).entries(array) aggregates values using the specified rollup function',
        () {
      Function min = (List x) => x.reduce((a, b) => a <= b ? a : b);
      Function max = (List x) => x.reduce((a, b) => a >= b ? a : b);
      Function minmax = (List x) => [min(x), max(x)];
      var nest = Nest()..rollup((List e) => e.length);
      var res = nest.entries([1, 2, 3, 4, 5]);
      expect(res, 5);
      var n2 = Nest()..rollup(min);
      expect(n2.entries([1, 2, 3, 4, 5]), 1);
      var n3 = Nest()..rollup(minmax);
      expect(n3.entries([1, 2, 3, 4, 5]), [1, 5]);
    });

    test(
        'nest.key(key).rollup(rollup).entries(array) aggregates values per key '
        'using the specified rollup function', () {
      var a = {'foo': 1}, b = {'foo': 1}, c = {'foo': 2};
      var nest = Nest()
        ..key((e) => e['foo'])
        ..rollup((List e) => e.length);
      expect(nest.entries([a, b, c]), [
        {'key': 1, 'values': 2},
        {'key': 2, 'values': 1}
      ]);
    });

//  test('not allowed to nest map a List of input values ', () {
//    Nest nest = new Nest();
//    expect(() => nest.map([1, 2, 3]) == [1, 2, 3], throwsA(new Error()));
//  });

    test('nest map one key', () {
      var nest = Nest()..key((Map e) => e['foo']);
      var xs = [
        {'foo': 1},
        {'foo': 1},
        {'foo': 2},
      ];
      expect(nest.map(xs), {
        1: [
          {'foo': 1},
          {'foo': 1},
        ],
        2: [
          {'foo': 2}
        ]
      });
    });
    test('nest map with two keys', () {
      var nest = Nest()
        ..key((Map e) => e['foo'])
        ..key((Map e) => e['bar']);
      expect(nest.map([a, b, c, d, e, f]), {
        1: {
          'a': [a, b],
          'b': [d, e]
        },
        2: {
          'a': [c],
          'b': [f]
        }
      });
    });
  });


  group('Nest test (barley data):', () {
    test('barley data nest by year/variety', () {
      var barley = loadDataBarley();
      var nest = Nest()..key((d) => d['year'])..key((d) => d['variety']);
      List res = nest.entries(barley);
      expect(res.length, 2);
    });

  });
}

void main() {
  tests();
}
