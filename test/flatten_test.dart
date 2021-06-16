library test.collections.flattenmap;

import 'package:dama/dama.dart';
import 'package:table/src/nest.dart';
import 'package:test/test.dart';
import 'package:table/src/flatten_map.dart';

void test1() {
  var data = {'A': 10, 'B': 20, 'C': 30};
  var res = flattenMap(data, ['level0', 'value']);
  test('flattenMap, one nesting level', () {
    expect(res, [
      {'level0': 'A', 'value': 10},
      {'level0': 'B', 'value': 20},
      {'level0': 'C', 'value': 30},
    ]);
  });
}

void test2() {
  var data = {
    'B1': {'Jan15': 1, 'Feb15': 2},
    'B2': {'Jan15': 3, 'Feb15': 4},
    'B3': {'Jan15': 5, 'Feb15': 6}
  };

  //res.forEach(print);
  test('flattenMap, two nesting levels', () {
    List? res = flattenMap(data, ['level0', 'level1', 'value']);
    expect(res, [
      {'level0': 'B1', 'level1': 'Jan15', 'value': 1},
      {'level0': 'B1', 'level1': 'Feb15', 'value': 2},
      {'level0': 'B2', 'level1': 'Jan15', 'value': 3},
      {'level0': 'B2', 'level1': 'Feb15', 'value': 4},
      {'level0': 'B3', 'level1': 'Jan15', 'value': 5},
      {'level0': 'B3', 'level1': 'Feb15', 'value': 6},
    ]);
  });
  test('flattenMap, two nesting levels, show only one', () {
    List? res = flattenMap(data, ['tag']);
    expect(res, [
      {'tag': 'B1', 'Jan15': 1, 'Feb15': 2},
      {'tag': 'B2', 'Jan15': 3, 'Feb15': 4},
      {'tag': 'B3', 'Jan15': 5, 'Feb15': 6},
    ]);
  });
}

void test3() {
  var data = {
    'A1': {
      'B1': {'C1': 1, 'C2': 2},
      'B2': {'C1': 3, 'C2': 4}
    },
    'A2': {
      'B1': {'C1': 5, 'C2': 6},
      'B2': {'C1': 7, 'C2': 8}
    },
  };
  test('flattenMap, three nesting levels', () {
    var res = flattenMap(data, ['level0', 'level1', 'level2', 'value']);
    expect(res, [
      {'value': 1, 'level2': 'C1', 'level1': 'B1', 'level0': 'A1'},
      {'value': 2, 'level2': 'C2', 'level1': 'B1', 'level0': 'A1'},
      {'value': 3, 'level2': 'C1', 'level1': 'B2', 'level0': 'A1'},
      {'value': 4, 'level2': 'C2', 'level1': 'B2', 'level0': 'A1'},
      {'value': 5, 'level2': 'C1', 'level1': 'B1', 'level0': 'A2'},
      {'value': 6, 'level2': 'C2', 'level1': 'B1', 'level0': 'A2'},
      {'value': 7, 'level2': 'C1', 'level1': 'B2', 'level0': 'A2'},
      {'value': 8, 'level2': 'C2', 'level1': 'B2', 'level0': 'A2'},
    ]);
  });
  test('flattenMap, 3 nesting levels, show only two', () {
    var res = flattenMap(data, ['level0', 'level1']);
    expect(res, [
      {'level0': 'A1', 'level1': 'B1', 'C1': 1, 'C2': 2},
      {'level0': 'A1', 'level1': 'B2', 'C1': 3, 'C2': 4},
      {'level0': 'A2', 'level1': 'B1', 'C1': 5, 'C2': 6},
      {'level0': 'A2', 'level1': 'B2', 'C1': 7, 'C2': 8},
    ]);
  });
  test('flattenMap, 3 nesting levels with names', () {
    var res = flattenMap(data, ['levelA', 'levelB', 'levelC', 'value']);
    expect(res, [
      {'value': 1, 'levelC': 'C1', 'levelB': 'B1', 'levelA': 'A1'},
      {'value': 2, 'levelC': 'C2', 'levelB': 'B1', 'levelA': 'A1'},
      {'value': 3, 'levelC': 'C1', 'levelB': 'B2', 'levelA': 'A1'},
      {'value': 4, 'levelC': 'C2', 'levelB': 'B2', 'levelA': 'A1'},
      {'value': 5, 'levelC': 'C1', 'levelB': 'B1', 'levelA': 'A2'},
      {'value': 6, 'levelC': 'C2', 'levelB': 'B1', 'levelA': 'A2'},
      {'value': 7, 'levelC': 'C1', 'levelB': 'B2', 'levelA': 'A2'},
      {'value': 8, 'levelC': 'C2', 'levelB': 'B2', 'levelA': 'A2'},
    ]);
  });
}

void test2Names() {
  test('flattenMap, extra levelName get ignored', () {
    var data = {
      'B1': {'Jan15': 1, 'Feb15': 2},
      'B2': {'Jan15': 3, 'Feb15': 4},
      'B3': {'Jan15': 5, 'Feb15': 6}
    };
    var res = flattenMap(data, ['levelB', 'month', 'count', 'value']);
    //res.forEach(print);
    expect(res, [
      {'levelB': 'B1', 'month': 'Jan15', 'count': 1},
      {'levelB': 'B1', 'month': 'Feb15', 'count': 2},
      {'levelB': 'B2', 'month': 'Jan15', 'count': 3},
      {'levelB': 'B2', 'month': 'Feb15', 'count': 4},
      {'levelB': 'B3', 'month': 'Jan15', 'count': 5},
      {'levelB': 'B3', 'month': 'Feb15', 'count': 6},
    ]);
  });

  test('flattenMap, one fewer levelName keeps the map', () {
    var a = {
      0: {'CT': 10, 'MA': 11},
      1: {'CT': 12, 'MA': 13},
    };
    var bux = flattenMap(a, ['index']);
    //bux.forEach(print);
    expect(bux, [
      {'index': 0, 'CT': 10, 'MA': 11},
      {'index': 1, 'CT': 12, 'MA': 13},
    ]);
  });
}

void extractValuesTest() {
  group('extract nested map', () {
    test('level 1 map', () {
      var m1 = {
        'A1': [1],
        'B1': [2]
      };
      var res = extractValues(m1);
      expect(res, [
        [1],
        [2]
      ]);
    });
    test('level 2 map', () {
      var m1 = {
        'A': {
          'AA': [1, 2],
          'AB': [3, 4],
        },
        'B': {
          'BA': [5, 6],
          'BB': [7, 8],
        }
      };
      var res = extractValues(m1);
      expect(res, [
        [1, 2],
        [3, 4],
        [5, 6],
        [7, 8],
      ]);
    });
    test('level 3 map', () {
      var m1 = {
        'A': {
          'AA': {
            'AAA': [1, 2],
            'AAB': [11, 22],
          },
          'AB': {
            'ABA': [3, 4],
            'ABB': [33, 44],
          },
        },
        'B': {
          'BA': [5, 6],
          'BB': [7, 8],
        }
      };
      var res = extractValues(m1);
      expect(res, [
        [1, 2],
        [11, 22],
        [3, 4],
        [33, 44],
        [5, 6],
        [7, 8],
      ]);
    });
  });
}

void main() {
  group('flattenMap tests:', () {
    test1();
    test2();
    test3();
    test2Names();
    extractValuesTest();
  });
}
