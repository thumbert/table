

library test.nest;

import 'package:table/src/nest.dart';
import 'package:test/test.dart';
import 'data.dart';


barleyTests() {
  List<Map> barley = loadDataBarley();

  test('barley data nest by year/variety', () {
    Nest nest = new Nest()..key((d) => d['year'])..key((d) => d['variety']);

    List res = nest.entries(barley);
    //res.forEach((e) => print(e));
    expect(res.length, 2);
  });
}


simpleTests() {
  test('nest entries return the input in input order', () {
    Nest nest = new Nest();
    expect(nest.entries([1, 2, 3]), [1, 2, 3]);
    expect(nest.entries([1, 3, 2]), [1, 3, 2]);
    expect(nest.entries([3, 2, 1]), [3, 2, 1]);
  });

  Map a = {'foo': 1, 'bar': 'a'};
  Map b = {'foo': 1, 'bar': 'a'};
  Map c = {'foo': 2, 'bar': 'a'};
  Map d = {'foo': 1, 'bar': 'b'};
  Map e = {'foo': 1, 'bar': 'b'};
  Map f = {'foo': 2, 'bar': 'b'};
  test('nest one level, get entries', () {
    Nest nest = new Nest()..key((e) => e['foo']);
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
    Nest nest = new Nest()..key((e) => e['foo'])..key((e) => e['bar']);
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
    Nest nest = new Nest()..rollup((List e) => e.length);
    var res = nest.entries([1, 2, 3, 4, 5]);
    expect(res, 5);
    Nest n2 = new Nest()..rollup(min);
    expect(n2.entries([1, 2, 3, 4, 5]), 1);
    Nest n3 = new Nest()..rollup(minmax);
    expect(n3.entries([1, 2, 3, 4, 5]), [1, 5]);
  });

  test(
      'nest.key(key).rollup(rollup).entries(array) aggregates values per key '
          'using the specified rollup function', () {
    var a = {'foo': 1}, b = {'foo': 1}, c = {'foo': 2};
    Nest nest = new Nest()
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
    Nest nest = new Nest()..key((Map e) => e['foo']);
    var a = {'foo': 1}, b = {'foo': 1}, c = {'foo': 2};
    expect(nest.map([a, b, c]), {
      1: [a, b],
      2: [c]
    });
  });


  test('nest map with two keys', () {
    Nest nest = new Nest()..key((Map e) => e['foo'])..key((Map e) => e['bar']);
    expect(nest.map([a, b, c, d, e, f]), {
      1: {'a': [a, b],
        'b': [d, e]},
      2: {'a': [c],
        'b': [f]}
    });
  });


}

main() {
  group('Nest tests:', (){
    simpleTests();
    barleyTests();
  });
}



