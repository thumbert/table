library test.collections.flattenmap;

import 'package:test/test.dart';
import 'package:table/src/flattenMap.dart';


test1() {
  Map data = {'A': 10, 'B': 20, 'C': 30};
  List res = flattenMap(data);
  //res.forEach(print);
  test('flattenMap, one nesting level', () {
    expect(res, [
      {'level0': 'A', 'value': 10},
      {'level0': 'B', 'value': 20},
      {'level0': 'C', 'value': 30},
    ]);
  });
}

test2() {
  Map data = {
    'B1': {'Jan15': 1, 'Feb15': 2},
    'B2': {'Jan15': 3, 'Feb15': 4},
    'B3': {'Jan15': 5, 'Feb15': 6}
  };
  List res = flattenMap(data);
  //res.forEach(print);
  test('flattenMap, two nesting levels', () {
    expect(res, [
      {'level0': 'B1', 'level1': 'Jan15', 'value': 1},
      {'level0': 'B1', 'level1': 'Feb15', 'value': 2},
      {'level0': 'B2', 'level1': 'Jan15', 'value': 3},
      {'level0': 'B2', 'level1': 'Feb15', 'value': 4},
      {'level0': 'B3', 'level1': 'Jan15', 'value': 5},
      {'level0': 'B3', 'level1': 'Feb15', 'value': 6},
    ]);
  });
}

test3() {
  Map data = {
    'A1': {
      'B1': {'C1': 1, 'C2': 2},
      'B2': {'C1': 3, 'C2': 4}
    },
    'A2': {
      'B1': {'C1': 5, 'C2': 6},
      'B2': {'C1': 7, 'C2': 8}
    },
  };
  List res = flattenMap(data);
  //res.forEach(print);
  test('flattenMap, three nesting levels', () {
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

}

test3Names() {
  Map data = {
    'A1': {
      'B1': {'C1': 1, 'C2': 2},
      'B2': {'C1': 3, 'C2': 4}
    },
    'A2': {
      'B1': {'C1': 5, 'C2': 6},
      'B2': {'C1': 7, 'C2': 8}
    },
  };
  List res = flattenMap(data, levelNames: ['levelA', 'levelB', 'levelC']);
  //res.forEach(print);
  test('flattenMap, three nesting levels with names', () {
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

test2Names() {
  Map data = {
    'B1': {'Jan15': 1, 'Feb15': 2},
    'B2': {'Jan15': 3, 'Feb15': 4},
    'B3': {'Jan15': 5, 'Feb15': 6}
  };
  List res = flattenMap(data, levelNames: ['levelB', 'month', 'count']);
  //res.forEach(print);
  test('flattenMap, two nesting levels with names', () {
    expect(res, [
      {'levelB': 'B1', 'month': 'Jan15', 'count': 1},
      {'levelB': 'B1', 'month': 'Feb15', 'count': 2},
      {'levelB': 'B2', 'month': 'Jan15', 'count': 3},
      {'levelB': 'B2', 'month': 'Feb15', 'count': 4},
      {'levelB': 'B3', 'month': 'Jan15', 'count': 5},
      {'levelB': 'B3', 'month': 'Feb15', 'count': 6},
    ]);
  });
}

extractValuesTest() {
  group('extract nested map', () {
    test('level 1 map', () {
      Map m1 = {
        'A1': [1],
        'B1': [2]
      };
      var res = ldz.extractValues(m1);
      expect(res, [
        [1],
        [2]
      ]);
    });
    test('level 2 map', () {
      Map m1 = {
        'A': {
          'AA': [1, 2],
          'AB': [3, 4],
        },
        'B': {
          'BA': [5, 6],
          'BB': [7, 8],
        }
      };
      var res = ldz.extractValues(m1);
      expect(res, [
        [1, 2],
        [3, 4],
        [5, 6],
        [7, 8],
      ]);
    });
    test('level 3 map', () {
      Map m1 = {
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
      var res = ldz.extractValues(m1);
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



main() {
  test1();
  test2();
  test3();
  test2Names();
  test3Names();
  extractValuesTest();
}


