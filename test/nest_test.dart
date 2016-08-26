

library test.nest;

import 'package:table/src/nest.dart';
import 'package:test/test.dart';

List<Map> loadDataBarley() {
  return [
    {
      "yield": 27,
      "variety": "Manchuria",
      "year": "1931",
      "site": "University Farm"
    },
    {
      "yield": 48.86667,
      "variety": "Manchuria",
      "year": "1931",
      "site": "Waseca"
    },
    {
      "yield": 27.43334,
      "variety": "Manchuria",
      "year": "1931",
      "site": "Morris"
    },
    {
      "yield": 39.93333,
      "variety": "Manchuria",
      "year": "1931",
      "site": "Crookston"
    },
    {
      "yield": 32.96667,
      "variety": "Manchuria",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {
      "yield": 28.96667,
      "variety": "Manchuria",
      "year": "1931",
      "site": "Duluth"
    },
    {
      "yield": 43.06666,
      "variety": "Glabron",
      "year": "1931",
      "site": "University Farm"
    },
    {"yield": 55.2, "variety": "Glabron", "year": "1931", "site": "Waseca"},
    {"yield": 28.76667, "variety": "Glabron", "year": "1931", "site": "Morris"},
    {
      "yield": 38.13333,
      "variety": "Glabron",
      "year": "1931",
      "site": "Crookston"
    },
    {
      "yield": 29.13333,
      "variety": "Glabron",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {"yield": 29.66667, "variety": "Glabron", "year": "1931", "site": "Duluth"},
    {
      "yield": 35.13333,
      "variety": "Svansota",
      "year": "1931",
      "site": "University Farm"
    },
    {
      "yield": 47.33333,
      "variety": "Svansota",
      "year": "1931",
      "site": "Waseca"
    },
    {
      "yield": 25.76667,
      "variety": "Svansota",
      "year": "1931",
      "site": "Morris"
    },
    {
      "yield": 40.46667,
      "variety": "Svansota",
      "year": "1931",
      "site": "Crookston"
    },
    {
      "yield": 29.66667,
      "variety": "Svansota",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {"yield": 25.7, "variety": "Svansota", "year": "1931", "site": "Duluth"},
    {
      "yield": 39.9,
      "variety": "Velvet",
      "year": "1931",
      "site": "University Farm"
    },
    {"yield": 50.23333, "variety": "Velvet", "year": "1931", "site": "Waseca"},
    {"yield": 26.13333, "variety": "Velvet", "year": "1931", "site": "Morris"},
    {
      "yield": 41.33333,
      "variety": "Velvet",
      "year": "1931",
      "site": "Crookston"
    },
    {
      "yield": 23.03333,
      "variety": "Velvet",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {"yield": 26.3, "variety": "Velvet", "year": "1931", "site": "Duluth"},
    {
      "yield": 36.56666,
      "variety": "Trebi",
      "year": "1931",
      "site": "University Farm"
    },
    {"yield": 63.8333, "variety": "Trebi", "year": "1931", "site": "Waseca"},
    {"yield": 43.76667, "variety": "Trebi", "year": "1931", "site": "Morris"},
    {
      "yield": 46.93333,
      "variety": "Trebi",
      "year": "1931",
      "site": "Crookston"
    },
    {
      "yield": 29.76667,
      "variety": "Trebi",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {"yield": 33.93333, "variety": "Trebi", "year": "1931", "site": "Duluth"},
    {
      "yield": 43.26667,
      "variety": "No. 457",
      "year": "1931",
      "site": "University Farm"
    },
    {"yield": 58.1, "variety": "No. 457", "year": "1931", "site": "Waseca"},
    {"yield": 28.7, "variety": "No. 457", "year": "1931", "site": "Morris"},
    {
      "yield": 45.66667,
      "variety": "No. 457",
      "year": "1931",
      "site": "Crookston"
    },
    {
      "yield": 32.16667,
      "variety": "No. 457",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {"yield": 33.6, "variety": "No. 457", "year": "1931", "site": "Duluth"},
    {
      "yield": 36.6,
      "variety": "No. 462",
      "year": "1931",
      "site": "University Farm"
    },
    {"yield": 65.7667, "variety": "No. 462", "year": "1931", "site": "Waseca"},
    {"yield": 30.36667, "variety": "No. 462", "year": "1931", "site": "Morris"},
    {
      "yield": 48.56666,
      "variety": "No. 462",
      "year": "1931",
      "site": "Crookston"
    },
    {
      "yield": 24.93334,
      "variety": "No. 462",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {"yield": 28.1, "variety": "No. 462", "year": "1931", "site": "Duluth"},
    {
      "yield": 32.76667,
      "variety": "Peatland",
      "year": "1931",
      "site": "University Farm"
    },
    {
      "yield": 48.56666,
      "variety": "Peatland",
      "year": "1931",
      "site": "Waseca"
    },
    {
      "yield": 29.86667,
      "variety": "Peatland",
      "year": "1931",
      "site": "Morris"
    },
    {"yield": 41.6, "variety": "Peatland", "year": "1931", "site": "Crookston"},
    {
      "yield": 34.7,
      "variety": "Peatland",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {"yield": 32, "variety": "Peatland", "year": "1931", "site": "Duluth"},
    {
      "yield": 24.66667,
      "variety": "No. 475",
      "year": "1931",
      "site": "University Farm"
    },
    {"yield": 46.76667, "variety": "No. 475", "year": "1931", "site": "Waseca"},
    {"yield": 22.6, "variety": "No. 475", "year": "1931", "site": "Morris"},
    {"yield": 44.1, "variety": "No. 475", "year": "1931", "site": "Crookston"},
    {
      "yield": 19.7,
      "variety": "No. 475",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {"yield": 33.06666, "variety": "No. 475", "year": "1931", "site": "Duluth"},
    {
      "yield": 39.3,
      "variety": "Wisconsin No. 38",
      "year": "1931",
      "site": "University Farm"
    },
    {
      "yield": 58.8,
      "variety": "Wisconsin No. 38",
      "year": "1931",
      "site": "Waseca"
    },
    {
      "yield": 29.46667,
      "variety": "Wisconsin No. 38",
      "year": "1931",
      "site": "Morris"
    },
    {
      "yield": 49.86667,
      "variety": "Wisconsin No. 38",
      "year": "1931",
      "site": "Crookston"
    },
    {
      "yield": 34.46667,
      "variety": "Wisconsin No. 38",
      "year": "1931",
      "site": "Grand Rapids"
    },
    {
      "yield": 31.6,
      "variety": "Wisconsin No. 38",
      "year": "1931",
      "site": "Duluth"
    },
    {
      "yield": 26.9,
      "variety": "Manchuria",
      "year": "1932",
      "site": "University Farm"
    },
    {
      "yield": 33.46667,
      "variety": "Manchuria",
      "year": "1932",
      "site": "Waseca"
    },
    {
      "yield": 34.36666,
      "variety": "Manchuria",
      "year": "1932",
      "site": "Morris"
    },
    {
      "yield": 32.96667,
      "variety": "Manchuria",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 22.13333,
      "variety": "Manchuria",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {
      "yield": 22.56667,
      "variety": "Manchuria",
      "year": "1932",
      "site": "Duluth"
    },
    {
      "yield": 36.8,
      "variety": "Glabron",
      "year": "1932",
      "site": "University Farm"
    },
    {"yield": 37.73333, "variety": "Glabron", "year": "1932", "site": "Waseca"},
    {"yield": 35.13333, "variety": "Glabron", "year": "1932", "site": "Morris"},
    {
      "yield": 26.16667,
      "variety": "Glabron",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 14.43333,
      "variety": "Glabron",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {"yield": 25.86667, "variety": "Glabron", "year": "1932", "site": "Duluth"},
    {
      "yield": 27.43334,
      "variety": "Svansota",
      "year": "1932",
      "site": "University Farm"
    },
    {"yield": 38.5, "variety": "Svansota", "year": "1932", "site": "Waseca"},
    {
      "yield": 35.03333,
      "variety": "Svansota",
      "year": "1932",
      "site": "Morris"
    },
    {
      "yield": 20.63333,
      "variety": "Svansota",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 16.63333,
      "variety": "Svansota",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {
      "yield": 22.23333,
      "variety": "Svansota",
      "year": "1932",
      "site": "Duluth"
    },
    {
      "yield": 26.8,
      "variety": "Velvet",
      "year": "1932",
      "site": "University Farm"
    },
    {"yield": 37.4, "variety": "Velvet", "year": "1932", "site": "Waseca"},
    {"yield": 38.83333, "variety": "Velvet", "year": "1932", "site": "Morris"},
    {
      "yield": 32.06666,
      "variety": "Velvet",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 32.23333,
      "variety": "Velvet",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {"yield": 22.46667, "variety": "Velvet", "year": "1932", "site": "Duluth"},
    {
      "yield": 29.06667,
      "variety": "Trebi",
      "year": "1932",
      "site": "University Farm"
    },
    {"yield": 49.2333, "variety": "Trebi", "year": "1932", "site": "Waseca"},
    {"yield": 46.63333, "variety": "Trebi", "year": "1932", "site": "Morris"},
    {
      "yield": 41.83333,
      "variety": "Trebi",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 20.63333,
      "variety": "Trebi",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {"yield": 30.6, "variety": "Trebi", "year": "1932", "site": "Duluth"},
    {
      "yield": 26.43334,
      "variety": "No. 457",
      "year": "1932",
      "site": "University Farm"
    },
    {"yield": 42.2, "variety": "No. 457", "year": "1932", "site": "Waseca"},
    {"yield": 43.53334, "variety": "No. 457", "year": "1932", "site": "Morris"},
    {
      "yield": 34.33333,
      "variety": "No. 457",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 19.46667,
      "variety": "No. 457",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {"yield": 22.7, "variety": "No. 457", "year": "1932", "site": "Duluth"},
    {
      "yield": 25.56667,
      "variety": "No. 462",
      "year": "1932",
      "site": "University Farm"
    },
    {"yield": 44.7, "variety": "No. 462", "year": "1932", "site": "Waseca"},
    {"yield": 47, "variety": "No. 462", "year": "1932", "site": "Morris"},
    {
      "yield": 30.53333,
      "variety": "No. 462",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 19.9,
      "variety": "No. 462",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {"yield": 22.5, "variety": "No. 462", "year": "1932", "site": "Duluth"},
    {
      "yield": 28.06667,
      "variety": "Peatland",
      "year": "1932",
      "site": "University Farm"
    },
    {
      "yield": 36.03333,
      "variety": "Peatland",
      "year": "1932",
      "site": "Waseca"
    },
    {"yield": 43.2, "variety": "Peatland", "year": "1932", "site": "Morris"},
    {
      "yield": 25.23333,
      "variety": "Peatland",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 26.76667,
      "variety": "Peatland",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {
      "yield": 31.36667,
      "variety": "Peatland",
      "year": "1932",
      "site": "Duluth"
    },
    {
      "yield": 30,
      "variety": "No. 475",
      "year": "1932",
      "site": "University Farm"
    },
    {"yield": 41.26667, "variety": "No. 475", "year": "1932", "site": "Waseca"},
    {"yield": 44.23333, "variety": "No. 475", "year": "1932", "site": "Morris"},
    {
      "yield": 32.13333,
      "variety": "No. 475",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 15.23333,
      "variety": "No. 475",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {"yield": 27.36667, "variety": "No. 475", "year": "1932", "site": "Duluth"},
    {
      "yield": 38,
      "variety": "Wisconsin No. 38",
      "year": "1932",
      "site": "University Farm"
    },
    {
      "yield": 58.16667,
      "variety": "Wisconsin No. 38",
      "year": "1932",
      "site": "Waseca"
    },
    {
      "yield": 47.16667,
      "variety": "Wisconsin No. 38",
      "year": "1932",
      "site": "Morris"
    },
    {
      "yield": 35.9,
      "variety": "Wisconsin No. 38",
      "year": "1932",
      "site": "Crookston"
    },
    {
      "yield": 20.66667,
      "variety": "Wisconsin No. 38",
      "year": "1932",
      "site": "Grand Rapids"
    },
    {
      "yield": 29.33333,
      "variety": "Wisconsin No. 38",
      "year": "1932",
      "site": "Duluth"
    }
  ];
}

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
    List res = nest.entries([a, b, c, d, e, f]);
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

  test('not allowed to nest map a List of input values ', () {
    Nest nest = new Nest();
    expect(() => nest.map([1, 2, 3]) == [1, 2, 3], throws);
  });

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

  simpleTests();

  barleyTests();
}



