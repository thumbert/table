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

main() {
  test1();
  test2();
  test3();
}
